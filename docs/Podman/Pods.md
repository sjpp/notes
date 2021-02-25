# Create pods with Podman

## Nextcloud example

1. First create the pod which is just the structure

        podman pod create --name nc-test -p 8080:80

1. then add containers

        podman run -d --restart=always --pod=nc-test -e MYSQL_ROOT_PASSWORD="" -e MYSQL_DATABASE="nc" -e MYSQL_USER="nc_user" -e MYSQL_PASSWORD="nextcloud" --name=nc-db mariadb

        podman run --security-opt label=disable -d --restart=always --pod=nc-test -e NEXTCLOUD_TRUSTED_DOMAINS="domain.net" -e NEXTCLOUD_ADMIN_USER="admin" -e NEXTCLOUD_ADMIN_PASSWORD="nextcloud" -e MYSQL_DATABASE="nc" -e MYSQL_USER="nc_user" -e MYSQL_PASSWORD="nextcloud" -e MYSQL_HOST="127.0.0.1" -v ./ncdata:/var/www/html:z --name=nc-app --memory=128M nextcloud

Nextcloud must use 127.0.0.1 as DB host as all ports are managed by the pod.
