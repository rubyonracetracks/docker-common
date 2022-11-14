#!/bin/bash

# NOTE: set -o pipefail is needed to ensure that any error or failure causes the whole pipeline to fail.
# Without this specification, the CI status will provide a false sense of security by showing builds
# as succeeding in spite of errors or failures.
set -eo pipefail

# This script restarts Docker.

echo '---------------------------'
echo 'sudo service docker restart'
sudo service docker restart

wait

echo '--------------------------'
echo 'sudo service docker status'
sudo service docker status
