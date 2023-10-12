---
tags:
    - ssl
    - cert
    - libvirt
---

## Check SSL state

    openssl s_client -connect HOTE:443 -CApath /etc/ssl/certs


## Generate a self signed certificate

    # create custom CA
    
    CANAME=MyOrg-RootCA
    
    # optional, create a directory
    
    mkdir $CANAME
    cd $CANAME
    
    # generate aes encrypted private key
    
    openssl genrsa -aes256 -out $CANAME.key 4096
    
    # create certificate, 1826 days = 5 years, 3650 days = 10 years, 7300 days ± 20 years
    
    openssl req -x509 -new -nodes -key $CANAME.key -sha256 -days 1826 -out $CANAME.crt -subj '/CN=My Root CA/C=AT/ST=MyCountry/L=MyCity/O=MyOrganisation'
    
    # create certificate for service
    
    MYCERT=myserver.local
    openssl req -new -nodes -out $MYCERT.csr -newkey rsa:4096 -keyout $MYCERT.key -subj '/CN=My Firewall/C=AT/ST=MyCountry/L=MyCity/O=MyOrganisation'
    
    # create a v3 ext file for SAN properties
    
    cat > $MYCERT.v3.ext << EOF
    authorityKeyIdentifier=keyid,issuer
    basicConstraints=CA:FALSE
    keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
    subjectAltName = @alt_names
    [alt_names]
    DNS.1 = myserver.local
    DNS.2 = myserver1.local
    IP.1 = 192.168.1.1
    IP.2 = 192.168.2.1
    EOF
    
    # sign the certificate
    openssl x509 -req -in $MYCERT.csr -CA $CANAME.crt -CAkey $CANAME.key -CAcreateserial -out $MYCERT.crt -days 730 -sha256 -extfile $MYCERT.v3.ext

## Decode certif p12 

    openssl pkcs12 -in keyStore.pfx -out keyStore.pem -nodes

## Libvirt cert creation script

    #!/bin/bash
    
    SERVER_KEY=server-key.pem
    
    # creating a key for our ca
    if [ ! -e ca-key.pem ]; then
     openssl genrsa -des3 -out ca-key.pem 1024
    fi
    # creating a ca
    if [ ! -e ca-cert.pem ]; then
     openssl req -new -x509 -days 1095 -key ca-key.pem -out ca-cert.pem  -subj "/C=IL/L=Raanana/O=Red Hat/CN=my CA"
    fi
    # create server key
    if [ ! -e $SERVER_KEY ]; then
     openssl genrsa -out $SERVER_KEY 1024
    fi
    # create a certificate signing request (csr)
    if [ ! -e server-key.csr ]; then
     openssl req -new -key $SERVER_KEY -out server-key.csr -subj "/C=IL/L=Raanana/O=Red Hat/CN=my server"
    fi
    # signing our server certificate with this ca
    if [ ! -e server-cert.pem ]; then
     openssl x509 -req -days 1095 -in server-key.csr -CA ca-cert.pem -CAkey ca-key.pem -set_serial 01 -out server-cert.pem
    fi
    
    # now create a key that doesn't require a passphrase
    openssl rsa -in $SERVER_KEY -out $SERVER_KEY.insecure
    mv $SERVER_KEY $SERVER_KEY.secure
    mv $SERVER_KEY.insecure $SERVER_KEY
    
    # show the results (no other effect)
    openssl rsa -noout -text -in $SERVER_KEY
    openssl rsa -noout -text -in ca-key.pem
    openssl req -noout -text -in server-key.csr
    openssl x509 -noout -text -in server-cert.pem
    openssl x509 -noout -text -in ca-cert.pem
    
    # copy *.pem file to /etc/pki/libvirt-spice
    if [[ ! -d "/etc/pki/libvirt-spice" ]] 
    then
     mkdir -p /etc/pki/libvirt-spice
    fi
    cp ./*.pem /etc/pki/libvirt-spice
    
    # echo --host-subject
    echo "your --host-subject is" \"`openssl x509 -noout -text -in server-cert.pem | grep Subject: | cut -f 10- -d " "`\"
    
    echo "copy ca-cert.pem to %APPDATA%\spicec\spice_truststore.pem or ~/.spice/spice_truststore.pem in your clients"
