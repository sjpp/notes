# General Docker Tips and issues solutions

## this fixes the input device is not a TTY .. see https://github.com/docker/compose/issues/5696

    export COMPOSE_INTERACTIVE_NO_CLI=1

## Address a container in swarm mode

    SERVICE_NAME=${DEPLOY_STACK}
    # Get deployed service information as json output
    SERVICE_JSON=$(docker service ps $SERVICE_NAME --no-trunc --format '{{ json . }}' -f desired-state=running)
    # Parse the output, get swarm node on which service has been deployed
    SWARM_NODE=$(echo "$SERVICE_JSON" | jq -r '.Node')
    
    # Wait just to give time for service to be deployed
    sleep 10
    
    # Get container ID and run command via SSH on the swarm node
    ssh -t $SWARM_NODE "docker exec -it $(echo $SERVICE_JSON | jq -r '.Name').$(echo $SERVICE_JSON | jq -r '.ID') make permissions"

## Have `.env` vars exported when deploying a stack

    docker-compose config | docker stack deploy --compose-file - <STACK_NAME>

If there is a `.env` entry in the compose file, it will be read and vars replaced in the compose file.
