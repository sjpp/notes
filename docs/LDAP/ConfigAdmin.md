# Setup Config Admin

First of all, let’s search for the right entry in our ldap-tree:

    dr@tardis:# ldapsearch -LLL -Y EXTERNAL -H ldapi:/// -b cn=config

In this output we can find our `cn=admin,cn=config`

    dn: olcDatabase={0}config,cn=config
    objectClass: olcDatabaseConfig
    olcDatabase: {0}config
    olcAccess: {0}to * by dn.exact=gidNumber=0+uidNumber=0,cn=peercred,cn=external
     ,cn=auth manage by * break
     olcRootDN: cn=admin,cn=config

Now lets encode our password using the following command:

    slappasswd -h {SHA}

So we can create our modification.ldif now:

    dn: olcDatabase={0}config,cn=config
    changetype: modify
    add: olcRootPW
    olcRootPW: {SSHA}

And enable it with the following command

    ldapmodify -Y EXTERNAL -H ldapi:/// -f modification.ldif

*source:* https://tech.feedyourhead.at/content/openldap-set-config-admin-password
