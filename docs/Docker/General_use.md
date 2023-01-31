---
tags:
    - docker
---

## Remove image

    docker rmi $image_id

## Get img size

    docker image inspect img/name:label --format='{{.Size}}'

## Build image

    docker build --label myLabel --tag myTag:latest path/to/Dockerfile

## Tag for remote repo

    docker tag myTag:version git.server.tld:5000/myTag:version
    docker push git.server.tld:5000/myTag:version
