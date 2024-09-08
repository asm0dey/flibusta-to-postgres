#!/bin/bash
set -e
set -o pipefail

# ls -lah /backup
mkdir -p dump

for i in lib.libavtor.sql.gz lib.libtranslator.sql.gz lib.libavtorname.sql.gz lib.libbook.sql.gz lib.libfilename.sql.gz lib.libgenre.sql.gz lib.libgenrelist.sql.gz lib.libjoinedbooks.sql.gz lib.librate.sql.gz lib.librecs.sql.gz lib.libseqname.sql.gz lib.libseq.sql.gz;
do
  echo Downloading $i and restoring it to MariaDB
  FILE=dump/$i
  wget -c -O $FILE https://flibusta.is/sql/$i
  # gunzip -c $FILE | mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -h database-mariadb "$MYSQL_DATABASE"
done
# echo Loading MariaDB to Postgres with pgloader
# pgloader mysql://$MYSQL_USER:$MYSQL_PASSWORD@database-mariadb/main postgresql://$POSTGRES_APPLICATION_USER:$POSTGRES_APPLICATION_USER_PASSWORD@postgres/$POSTGRES_APPLICATION_DATABASE
# echo Dumping Postgres to file
# PGUSER=$POSTGRES_APPLICATION_USER PGPASSWORD=$POSTGRES_APPLICATION_USER_PASSWORD PGDATABASE=$POSTGRES_APPLICATION_DATABASE PGHOST=postgres pg_dump > /backup/backup.sql
# mysql2sqlite -d "$MYSQL_DATABASE" -u "$MYSQL_USER" --mysql-password "$MYSQL_PASSWORD" -h database-mariadb -f /data/flibusta.db
