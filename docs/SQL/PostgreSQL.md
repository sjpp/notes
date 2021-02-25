---
tags:
    - server
    - linux
    - db
    - cli
---

## PostgreSQL

### Gérer PostGreSQL

* Se connecter en user postgres:

        sudo -u postgres -i

* Se connecter à postgresql

        psql

* Lister les bases (une fois connecté) :

        \l

* Lister tous les schémas :

        \dn

* Lister les tables d'un schéma :

        \dt nom_schema.*

### Exporter une base (sans être connecté)

    pg_dump NOM_BASE > Fichier.sql

### Importer des données dans une base existante

    psql -U USERNAME NOM_BASE < Fichier.sql

    CREATE USER davide WITH PASSWORD 'pass';

    GRANT ALL PRIVILEGES ON DATABASE kinds TO manuel;

    ALTER DATABASE kanboard OWNER TO u_base;

### Mettre à jour un mot de passe

    CREATE EXTENSION pgcrypto;
    update users set password = crypt('pass', gen_salt('bf')) where username = 'admin';

### Passer des commandes en cli sans auth interactive

    PGPASSFILE=<(echo localhost:5432:db_siao_extraction:u_siao_extraction:MON_PASS) psql -h localhost -p 5432 -d db_siao_extraction  -U u_siao_extraction -c "delete from urg_extraction_info;"

### Requeête les requêtes en cours ordonnées par âge en excluant la requête de requête 

    SELECT pid, age(query_start, clock_timestamp()), usename, query FROM pg_stat_activity WHERE query != '<IDLE>' AND query NOT ILIKE '%pg_stat_activity%' AND query NOT ILIKE '%SET extra%' ORDER BY query_start asc;

### Tuer une requête en cours

    select pg_terminate_backend (N° requête);

