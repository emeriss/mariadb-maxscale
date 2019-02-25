#!/bin/bash
#

# The used containers
containers="maxscale mariadb1 mariadb2 mariadb3"

# Do things for containers
for c in ${containers} ; do
    # Stop all running containers
    echo "Stopping container $c"
    docker stop $c > /dev/null

    # Remove all running containers
    echo "Removing container $c"
    docker rm $c > /dev/null
done

# Build the new containers
docker-compose up -d

# Dirty but needed to init the containers on slower systems
sleep 20

# Execute the script to initiate slave replication
docker exec -ti mariadb2 '/tmp/prepare.sh'
docker exec -ti mariadb3 '/tmp/prepare.sh'
