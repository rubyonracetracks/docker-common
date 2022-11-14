#!/bin/bash

# NOTE: set -o pipefail is needed to ensure that any error or failure causes the whole pipeline to fail.
# Without this specification, the CI status will provide a false sense of security by showing builds
# as succeeding in spite of errors or failures.
set -eo pipefail

# This script is used in continuous integration for pushing a new Docker 
# image IF the main branch is in use.

DOCKER_IMAGE=$1

T_BEGIN=$(date +'%s')

echo '-------------------------------------'
echo "docker images -a | grep $DOCKER_IMAGE"
docker images -a | grep $DOCKER_IMAGE

echo '-----------------------------------------'
echo "BEGIN: pushing Docker image $DOCKER_IMAGE"
echo '-----------------------------------------'

docker push $DOCKER_IMAGE

echo '--------------------------------------------'
echo "FINISHED: pushing Docker image $DOCKER_IMAGE"
echo '--------------------------------------------'

T_FINISH=$(date +'%s')
T_ELAPSED=$(($T_FINISH-$T_BEGIN))
echo '------------------------------------------------'
echo "Time consumed to push Docker image $DOCKER_IMAGE"
echo "$(($T_ELAPSED / 60)) minutes and $(($T_ELAPSED % 60)) seconds"
