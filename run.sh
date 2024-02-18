#!/bin/bash
set -e
set -o pipefail

for i in lib.libavtor.sql.gz lib.libtranslator.sql.gz lib.libavtorname.sql.gz lib.libbook.sql.gz lib.libfilename.sql.gz lib.libgenre.sql.gz lib.libgenrelist.sql.gz lib.libjoinedbooks.sql.gz lib.librate.sql.gz lib.librecs.sql.gz lib.libseqname.sql.gz lib.libseq.sql.gz;
do
  echo Downloading $i and restoring it to MariaDB
  curl -s https://flibusta.is/sql/$i | gunzip -c | mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -h database-mariadb "$MYSQL_DATABASE"
done
echo Dumping MariaDB database in Postgres compatibility format
mysqldump -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -h database-mariadb --compatible=postgres "$MYSQL_DATABASE" > /backup/backup.sql
echo Restoring the backup to Postgres to verify correctness
PGPASSWORD="$POSTGRES_APPLICATION_USER_PASSWORD" psql --set ON_ERROR_STOP=on -U "$POSTGRES_APPLICATION_USER" -h datapase-postgres -d "$POSTGRES_APPLICATION_DATABASE" -f /backup/backup.sql
