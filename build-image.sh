#!/bin/bash

# NOTE: set -o pipefail is needed to ensure that any error or failure causes the whole pipeline to fail.
# Without this specification, the CI status will provide a false sense of security by showing builds
# as succeeding in spite of errors or failures.
set -eo pipefail

source variables.sh

echo '************************************'
echo "Docker image to build: $DOCKER_IMAGE"
echo '************************************'

wait
wget -O - https://raw.githubusercontent.com/rubyonracetracks/docker-common/main/delete-containers.sh | bash -s "$DOCKER_CONTAINER"
wait
wget -O - https://raw.githubusercontent.com/rubyonracetracks/docker-common/main/delete-images.sh | bash -s "$DOCKER_IMAGE"
wait

DATE=`date +%Y_%m%d_%H%M_%S`
echo '--------------------------------'
echo 'Date and time at start of build:'
echo $DATE
DIR_LOG=$PWD/log
mkdir -p $DIR_LOG

wget -O - https://raw.githubusercontent.com/rubyonracetracks/docker-common/main/customize.sh | bash

echo '****************************'
echo "BEGIN building $DOCKER_IMAGE"
echo '****************************'

docker build -t $DOCKER_IMAGE . 2>&1 | tee $DIR_LOG/build-$DATE.txt

echo '*******************************'
echo "Finished building $DOCKER_IMAGE"
echo '*******************************'

echo '------------------------------'
echo 'Date and time at end of build:'
date +%Y_%m%d_%H%M_%S

echo '-------------------------------------'
echo "docker images -a | grep $DOCKER_IMAGE"
docker images -a | grep $DOCKER_IMAGE
