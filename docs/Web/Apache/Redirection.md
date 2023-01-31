# Redirections Apache

## HTTP => HTTPS

    RewriteEngine On
    RewriteCond %{HTTPS} !=on
    RewriteRule ^/?(.*) https://%{SERVER_NAME}/$1 [R,L]

## Pour un domaine spécifique

    <If "%{HTTP_HOST} = 'www.example.com'">
	    Redirect "/" "http://www.new-example.com/"
    </If>