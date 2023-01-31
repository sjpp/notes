---
tags:
    - server
    - db
    - linux
    - cli
---

## MySQL and MariaDB tricks

### Dumper une table

        mysqldump $base $table

### Restaurer le dump d'une table

        mysql -uroot -p DatabaseName < path\TableName.sql

### Extraire table d'un dump

    grep -n "Table structure" [MySQL_dump_filename].sql

This will provide you with the starting line number in the MySQL dump file which defines each table. Using this, determine the starting and ending line numbers of the table you need (the ending line number will be the starting line number of the next table, minus one).

### extract the table from the MySQL database dump file

    sed -n '[starting_line_number],[ending_line_number] p' [MySQL_dump_filename].sql > [table_output_filename].sql

### The last remaining step is to use the extracted table

    mysql -u root -p [some_database_name] < [table_output_filename].sql

### Gérer les bases de données

    show databases;

* Utiliser une base

        USE nom_base;

* Listes les tables dans cette base

        show tables;

* Pour crée une base de données, saisir simplement

        CREATE DATABASE superbase;

* Pour la supprimer

        DROP DATABASE superbase;

### Gestion des utilisateurs

* Voir tous les utilisateurs

        select * from mysql.user;

#### Pour créer un utilisateur

* Quelque soit l'hôte

        CREATE USER 'utilisateur'@'%' IDENTIFIED BY 'motdepasse';

* Que pour localhost

        CREATE USER 'utilisateur'@'localhost' IDENTIFIED BY 'motdepasse';

#### Attribuer des droits aux utilisateurs

Pour attribuer tous les droits à un utilisateur (en faire en quelque sortes un deuxième root) :

        GRANT ALL PRIVILEGES ON * . * TO 'utilisateur'@'localhost' IDENTIFIED BY 'motdepasse' WITH GRANT OPTION MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0 ;

* Ou même en lecture seule

        GRANT SELECT ON * . * TO 'utilisateur'@'localhost' IDENTIFIED BY 'motdepasse' ;

* Tous les droits sur une base

        GRANT ALL PRIVILEGES ON mydb.* TO 'myuser'@'localhost' WITH GRANT OPTION;

* On peut faire du 2 en 1. Voici un exemple pour la création d'un utilisateur sans mot de passe avec des droits en lecture seule

        GRANT SELECT ON *.* TO 'ro'@'localhost';

* De la même façon, on peut supprimer ds droits avec REVOKE

        REVOKE ALL ON *.* FROM 'utilisateur'@'localhost';

### Changer un mot de passe d'utilisateur de MySQL

* Cette commande fonctionne uniquement pour MySQL

        UPDATE mysql.USER SET password=PASSWORD("nouveau") WHERE USER="utilisateur";

* Pour voir les utilisateurs créés

        SELECT USER,host,password FROM mysql.USER;

* Pour un utilisateur donné, on peut voir ses droits de la façon suivante

        SHOW GRANTS FOR "utilisateur"@"localhost";

* View permissions for individual databases

        SELECT user, host, db, select_priv, insert_priv, grant_priv FROM mysql.db;

* Voir les GRANTS sur une table:

        select user from mysql.db where db='DB_NAME';

### Modifier mot de passe hasher en MD5

        UPDATE users SET Password = (MD5('1cb826899b7')) WHERE User = 'sgennet';

### Tables

#### Pour créer une table simple, voici un exemple

        CREATE TABLE table1 ( id INT(10) NOT NULL AUTO_INCREMENT COMMENT 'id, autoincrémenté', nom VARCHAR(20) NOT NULL, DATE DATE, message VARCHAR(255), PRIMARY KEY (id)); 

### How to Back Up and Restore a MySQL Database

If you're storing anything in MySQL databases that you do not want to lose, it is very important to make regular backups of your data to protect it from loss. This tutorial will show you two easy ways to backup and restore the data in your MySQL database. You can also use this process to move your data to a new web server.

Back up From the Command Line (using mysqldump)

If you have shell or telnet access to your web server, you can backup your MySQL data by using the mysqldump command. This command connects to the MySQL server and creates an SQL dump file. The dump file contains the SQL statements necessary to re-create the database. Here is the proper syntax:

    mysqldump --opt -u [uname] -p[pass] [dbname] > [backupfile.sql]

For example, to backup a database named 'Tutorials' with the username 'root' and with no password to a file tut_backup.sql, you should accomplish this command:

    mysqldump -u root -p Tutorials > tut_backup.sql

This command will backup the 'Tutorials' database into a file called tut_backup.sql which will contain all the SQL statements needed to re-create the database.

With mysqldump command you can specify certain tables of your database you want to backup. For example, to back up only php_tutorials and asp_tutorials tables from the 'Tutorials' database accomplish the command below. Each table name has to be separated by space.

    mysqldump -u root -p Tutorials php_tutorials asp_tutorials > tut_backup.sql

Sometimes it is necessary to back up more that one database at once. In this case you can use the --database option followed by the list of databases you would like to backup. Each database name has to be separated by space.

    mysqldump -u root -p --databases Tutorials Articles Comments > content_backup.sql

If you want to back up all the databases in the server at one time you should use the --all-databases option. It tells MySQL to dump all the databases it has in storage.

    mysqldump -u root -p --all-databases > alldb_backup.sql

The mysqldump command has also some other useful options:

    --add-drop-table: Tells MySQL to add a DROP TABLE statement before each CREATE TABLE in the dump.

    --no-data: Dumps only the database structure, not the contents.

    --add-locks: Adds the LOCK TABLES and UNLOCK TABLES statements you can see in the dump file.

The mysqldump command has advantages and disadvantages. The advantages of using mysqldump are that it is simple to use and it takes care of table locking issues for you. The disadvantage is that the command locks tables. If the size of your tables is very big mysqldump can lock out users for a long period of time.

### Back up your MySQL Database with Compress

If your mysql database is very big, you might want to compress the output of mysqldump. Just use the mysql backup command below and pipe the output to gzip, then you will get the output as gzip file.

    mysqldump -u [uname] -p[pass] [dbname] | gzip -9 > [backupfile.sql.gz]

If you want to extract the .gz file, use the command below:

    gunzip [backupfile.sql.gz]

### Restoring your MySQL Database

Above we backup the Tutorials database into tut_backup.sql file. To re-create the Tutorials database you should follow two steps:

* Create an appropriately named database on the target machine
* Load the file using the mysql command:

        mysql -u [uname] -p[pass] [db_to_restore] < [backupfile.sql]

* Have a look how you can restore your tut_backup.sql file to the Tutorials database.

        mysql -u root -p Tutorials < tut_backup.sql

* To restore compressed backup files you can do the following:

        gunzip < [backupfile.sql.gz] | mysql -u [uname] -p[pass] [dbname]

If you need to restore a database that already exists, you'll need to use mysqlimport command. The syntax for mysqlimport is as follows:

        mysqlimport -u [uname] -p[pass] [dbname] [backupfile.sql]

### Backing Up and Restoring using PHPMyAdmin

It is assumed that you have phpMyAdmin installed since a lot of web service providers use it. To backup your MySQL database using PHPMyAdmin just follow a couple of steps:

* Open phpMyAdmin.
* Select your database by clicking the database name in the list on the left of the screen.
* Click the Export link. This should bring up a new screen that says View dump of database (or something similar).
* In the Export area, click the Select All link to choose all of the tables in your database.
* In the SQL options area, click the right options.
* Click on the Save as file option and the corresponding compression option and then click the 'Go' button. A dialog box should appear prompting you to save the file locally.

### Restoring your database is easy as well as backing it up. Make the following:

* Open phpMyAdmin.
* Create an appropriately named database and select it by clicking the database name in the list on the left of the screen. If you would like to rewrite the backup over an existing database then click on the database name, select all the check boxes next to the table names and select Drop to delete all existing tables in the database.
* Click the SQL link. This should bring up a new screen where you can either type in SQL commands, or upload your SQL file.
* Use the browse button to find the database file.
* Click Go button. This will upload the backup, execute the SQL commands and re-create your database.
    
### Script création multiple

    #!/bin/bash

    while read line
    do
        DB=$(echo $line | awk '{print $1}') ; echo $DB
        USER=$(echo $line | awk '{print $2}') ; echo $USER
        PASS=$(echo $line | awk '{print $3}') ; echo $PASS

        mysql -e "CREATE DATABASE ${DB};"
        mysql -e "CREATE USER ${USER}@localhost IDENTIFIED BY '${PASS}';"
        mysql -e "GRANT ALL PRIVILEGES ON ${DB}.* TO '${USER}'@'localhost';"
        mysql -e "FLUSH PRIVILEGES;"
    done<listing3

### Mettre à jour le pass d'un user

    ALTER USER 'userName'@'localhost' IDENTIFIED BY 'New-Password-Here';
    SET PASSWORD FOR 'user-name-here'@'hostname' = PASSWORD('new-password');

### Purger les logs binaires

    PURGE BINARY LOGS TO 'mysql-bin.010';
    PURGE BINARY LOGS BEFORE '2008-04-02 22:46:26';

### Gérer les processus

    mysql> SHOW processlist;

#### Tuer un process

    KILL QUERY id

#### Tuer plein de process

    select concat('KILL ',id,';') from information_schema.processlist where user='fronte' and command='Query' into outfile '/tmp/a.txt';
    source /tmp/a.txt;

### Afficher les entetes des colonnes d'une table

    select column_name from information_schema.columns where table_name='<table_name>';

### Voir les moteurs de table

    SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES WHERE TABLE_SCHEMA = \"$DB\" ;
