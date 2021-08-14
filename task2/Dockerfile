FROM postgres:13

RUN mkdir -p /docker-entrypoint-initdb.d
COPY ./sql/DDL.sql /docker-entrypoint-initdb.d/DDL.sql

EXPOSE 5432

CMD ["/docker-entrypoint.sh", "postgres"]