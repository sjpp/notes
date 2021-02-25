---
tags:
    - docker
    - backup
---

## Docker container backup

This config will describe a procedure of how to back up a Docker container as well as it will also show how to recover a Docker container from backup.

To understand the Docker container backup and recovery process we first need to understand the difference between docker image and docker container. A docker image contains an operating system with possibly one or more prefigured applications. Whereas, a docker container is a running instance created from an image.

When we need make a backup of a docker container we commit its current state and save it as a docker image.


    docker ps

    CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
    78727078a04b        debian:8            "/bin/bash"         13 seconds ago      Up 11 seconds                           container1

From the above output we see a running docker container named container1 with an ID 78727078a04b. We now use commit command to take a snapshot of its current running state:

    docker commit -p  78727078a04b  container1

    e09f9ac65c8b3095927c14ca0594868f73831bde0800ce66415afeb91aea93cf


With do above command we have first paused a running container with -p option, made a commit to save the entire snapshot as a docker image with a name container1:

    docker images
    REPOSITORY                      TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
    container1                      latest              e09f9ac65c8b        39 seconds ago      125.1 MB

Now we have a container backup saved as an image waiting to be redeployed again. If we wish to redeploy our container1 image on another docker host system we may push the image to some private docker repository:

    docker login
    docker push container1

or we can save it as a tar file and move it freely to any desired docker host system for a deployment:

    docker save -o ~/container1.tar container1

    ls -l ~/container1.tar
    -rw-r--r--. 1 root root 131017216 Jun 14 20:31 /root/container1.tar

## Docker container recovery

The above paragraphs explained how to backup a docker container. In this section we will discuss how recover from a docker backup.

In case that we have pushed our backed up docker container image to a private repository we can simply use docker run command to start a new instance from the container1 image. If we have transferred our container1.tar backup file to another docker host system we first need to load backed up tar file into a docker's local image repository:

    docker load -i /root/container1.tar

Confirm that the image was loaded with:

    docker images

Now we can use docker run command to start a new instance from the above loaded container1 image.
