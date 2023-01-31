# LetsEncrypt

Use LetsEncrypt with `webroot` and Apache2

`/etc/apache2/conf-available/le.conf`

```
Alias /.well-known/acme-challenge/ "/var/www/html/.well-known/acme-challenge/"
<Directory "/var/www/html/">
    AllowOverride None
    Options MultiViews Indexes SymLinksIfOwnerMatch IncludesNoExec
    Require method GET POST OPTIONS
</Directory>
```

`a2enconf le`

Then use Certbot with the following option `--webroot --webroot-path /var/www/html`

