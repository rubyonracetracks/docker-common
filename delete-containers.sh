#!/bin/bash

# NOTE: set -o pipefail is needed to ensure that any error or failure causes the whole pipeline to fail.
# Without this specification, the CI status will provide a false sense of security by showing builds
# as succeeding in spite of errors or failures.
set -eo pipefail

DOCKER_CONTAINER=$1

set +e

echo '----------------------------------------------------------'
echo "Killing and removing Docker containers ($DOCKER_CONTAINER)"
for i in $(docker ps -a | grep $DOCKER_CONTAINER | awk '{print $1}')
do
  docker kill $i; wait;
  docker rm -f $i; wait;
done;

echo '-------------------------------------'
echo "docker ps -a | grep $DOCKER_CONTAINER"
docker ps -a | grep $DOCKER_CONTAINER

set -e
