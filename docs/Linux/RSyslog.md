---
tags:
    - server
    - log
    - linux
---

## Setup for rsyslog configuration

    ### Provides TCP syslog reception
    module(load="imtcp" maxSessions="500")
    ### Config for secure TLS connection
    #    streamDriver.name="gtls"
    #    streamDriver.mode="1"
    #    streamDriver.authMode="x509/name"
    #    permittedPeer=["*.accelance.net","*.domain.tld"])

    ### Define name template for received logs
    $template RemoteHost,"/var/log/hosts/%HOSTNAME%/%programname%.log"

    ### Define rules to be applied to received logs
    #   here we send them to the dynamic files defined in above template
    ruleset(name="writeRemoteData"
        queue.type="fixedArray"
        queue.size="250000"
        queue.dequeueBatchSize="4096"
        queue.workerThreads="4"
        queue.workerThreadMinimumMessages="60000"
        ) {
        action(type="omfile" dynafile="RemoteHost"
        ioBufferSize="64k" flushOnTXEnd="off"
        asyncWriting="on")
    }

    ### Define input module
    input(type="imtcp"
        port="514"
        address="10.10.48.48"
        ruleset="writeRemoteData")
        
    
### pf rules
    pass quick proto tcp from { 213.162.55.19 } to { 10.10.48.48 } port 514
 
 
### configure log rotation for collected logs

    /var/log/hosts/*/*.log
    {
        missingok
        compress
        create 0400 root root
        daily
        dateformat %Y%m%d
        rotate 90
    }

