#!/bin/bash

# NOTE: set -o pipefail is needed to ensure that any error or failure causes the whole pipeline to fail.
# Without this specification, the CI status will provide a false sense of security by showing builds
# as succeeding in spite of errors or failures.
set -eo pipefail

DOCKER_IMAGE=$1

set +e

echo '--------------------------------------------------'
echo "Killing and removing Docker images ($DOCKER_IMAGE)"
for i in $(docker images -a | grep $DOCKER_IMAGE | awk '{print $3}')
do
  docker kill $i; wait;
  docker rmi -f $i; wait;
done;

echo '-------------------------------------'
echo "docker images -a | grep $DOCKER_IMAGE"
docker images -a | grep $DOCKER_IMAGE

set -e
