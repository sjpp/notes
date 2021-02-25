---
tags:
    - docker
    - db
---

## Postgres DB

    docker exec -t your-db-container pg_dumpall -c -U postgres  | gzip > dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql

## Restore your databases

    cat your_dump.sql | docker exec -i your-db-container psql -U postgres

## With mySQL

    cat dump.sql | docker-compose exec -T <mysql_container> mysql -u <db-username> -p<db-password> <db-name>
