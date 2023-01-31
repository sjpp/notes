# Create a local bucket for runners' cache

## Get the server binary

    curl -O https://dl.minio.io/server/minio/release/linux-amd64/minio

Make it executable:

    chmod +x minio
    mv minio /usr/local/bin

## Add dedicated user and set its rights

    useradd -r minio-user -s /sbin/nologin

    chown minio-user:minio-user /usr/local/bin/minio

Create the directory where *minio* will cache objects:

    mkdir /usr/local/share/minio
    chown minio-user:minio-user /usr/local/share/minio

## Configure the service

    mkdir /etc/minio
    chown minio-user:minio-user /etc/minio

    vim /etc/default/minio #add the following with your own credentials

    MINIO_VOLUMES="/usr/local/share/minio/
    MINIO_OPTS="-C /etc/minio --address 0.0.0.0:9005"
    MINIO_ACCESS_KEY="YOUR_SECRET_HERE"
    MINIO_SECRET_KEY="YOUR_SECRET_HERE"
    MINIO_REIGON="eu-west-1"
    MINIO_ROOT_USER="YOUR_SECRET_HERE"
    MINIO_ROOT_PASSWORD="YOUR_SECRET_HERE"

## Get the systemd unit file

    curl -O https://raw.githubusercontent.com/minio/minio-service/master/linux-systemd/minio.service
    mv minio.service /etc/systemd/system

Check that you have the following content:

    [Unit]
    Description=MinIO
    Documentation=https://docs.min.io
    Wants=network-online.target
    After=network-online.target
    AssertFileIsExecutable=/usr/local/bin/minio
    
    [Service]
    WorkingDirectory=/usr/local/
    
    User=minio-user
    Group=minio-user
    
    EnvironmentFile=/etc/default/minio
    ExecStartPre=/bin/bash -c "if [ -z \"${MINIO_VOLUMES}\" ]; then echo \"Variable MINIO_VOLUMES not set in /etc/default/minio\"; exit 1; fi"
    
    ExecStart=/usr/local/bin/minio server $MINIO_OPTS $MINIO_VOLUMES
    
    # Let systemd restart this service always
    Restart=always
    
    # Specifies the maximum file descriptor number that can be opened by this process
    LimitNOFILE=65536
    
    # Specifies the maximum number of threads this process can create
    TasksMax=infinity
    
    # Disable timeout logic and wait until process is stopped
    TimeoutStopSec=infinity
    SendSIGKILL=no
    
    [Install]
    WantedBy=multi-user.target
    
    # Built for ${project.name}-${project.version} (${project.name})

Reload *systemd* daemon:

    systemctl daemon-reload

Enable and start *minio* service:

    systemctl enable minio --now

Access the web interface, using specified credentials, at `https://minio.host.ip:9005`.
