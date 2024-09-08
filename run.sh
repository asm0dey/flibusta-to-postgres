#!/bin/bash
set -o pipefail
set -x

for f in /dump/*; do
  gunzip -c $f | mariadb -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -h mariadb "$MYSQL_DATABASE"
done
echo "load database
    from mysql://$MYSQL_USER:$MYSQL_PASSWORD@mariadb/$MYSQL_DATABASE
    into pgsql://$POSTGRES_APPLICATION_USER:$POSTGRES_APPLICATION_USER_PASSWORD@postgres/$POSTGRES_APPLICATION_DATABASE

  WITH create indexes, reset sequences, foreign keys

  SET maintenance_work_mem to '128MB', work_mem to '12MB';" > load.it
pgloader load.it
# pgloader mysql://"$MYSQL_USER":"$MYSQL_PASSWORD"@mariadb/"$MYSQL_DATABASE" pgsql://"$POSTGRES_APPLICATION_USER":"$POSTGRES_APPLICATION_USER_PASSWORD"@postgres/"$POSTGRES_APPLICATION_DATABASE"
echo postgres:5432:$POSTGRES_APPLICATION_DATABASE:$POSTGRES_APPLICATION_USER:$POSTGRES_APPLICATION_USER_PASSWORD > ~/.pgpass
chmod 600 ~/.pgpass
pg_dump -Fc -h postgres -U $POSTGRES_APPLICATION_USER $POSTGRES_APPLICATION_DATABASE > /backup/db.dump
