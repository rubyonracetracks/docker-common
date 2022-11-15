#!/bin/bash

# NOTE: set -o pipefail is needed to ensure that any error or failure causes the whole pipeline to fail.
# Without this specification, the CI status will provide a false sense of security by showing builds
# as succeeding in spite of errors or failures.
set -eo pipefail

# This script is used in continuous integration for testing a new Docker 
# image before pushing it.

source variables.sh

echo '-----------------------------------------'
echo "BEGIN: testing Docker image $DOCKER_IMAGE"
echo '-----------------------------------------'

for i in $(docker images -a | grep $DOCKER_IMAGE | awk '{print $3}')
do
  SCRIPT_TO_RUN='/usr/local/bin/check' # Script to run
  docker create -i -t -u='winner' $DOCKER_IMAGE $SCRIPT_TO_RUN
  wait
done;

echo '--------------------------------------------'
echo "FINISHED: testing Docker image $DOCKER_IMAGE"
echo '--------------------------------------------'

