FROM alpine
RUN apk update && apk upgrade && apk add mariadb-client postgresql-client bash curl pgloader
ENV WAIT_VERSION 2.7.2
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/$WAIT_VERSION/wait /wait
RUN chmod +x /wait
CMD ["sh", "-c", "/wait && /run.sh"]
VOLUME /backup
COPY run.sh .
RUN chmod +x run.sh && mkdir -p /backup
