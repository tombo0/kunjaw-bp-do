FROM mysql:latest

ENV MYSQL_ROOT_PASSWORD=s3k0l4hd3v0p5
ENV MYSQL_DATABASE=people
ENV MYSQL_USER=people
ENV MYSQL_PASSWORD=people

ADD crud_db.sql /docker-entrypoint-initdb.d

EXPOSE 3306