FROM ghcr.io/dimitri/pgloader:latest
ENV WAIT_VERSION 2.12.1
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/$WAIT_VERSION/wait /wait
RUN chmod +x /wait && apt-get update && apt-get install -y wget && wget https://r.mariadb.com/downloads/mariadb_repo_setup && chmod +x mariadb_repo_setup && ./mariadb_repo_setup && apt install -y mariadb-client
RUN install -d /usr/share/postgresql-common/pgdg && \
    apt install -y gnupg2 && \
    curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg && \
    sh -c 'echo "deb https://apt.postgresql.org/pub/repos/apt bookworm-pgdg main" > /etc/apt/sources.list.d/pgdg.list' && \
    apt-get update && apt-get -y install postgresql-client-16
COPY run.sh /run.sh
RUN chmod +x /run.sh
CMD ["sh", "-c", "/wait && /run.sh"]
