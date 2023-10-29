#!/bin/bash

# NOTE: set -o pipefail is needed to ensure that any error or failure causes the whole pipeline to fail.
# Without this specification, the CI status will provide a false sense of security by showing builds
# as succeeding in spite of errors or failures.
set -eo pipefail

STRING1="$1"
STRING2="$2"
DIR_NAME="$3"

# This script replaces a string with another string for all files in a given directory.

for FILENAME in "$DIR_NAME/*"; do
  wget -O - \
  https://raw.githubusercontent.com/rubyonracetracks/docker-common/main/replace-string-in-file.sh \
  | bash -s "$STRING1" "$STRING2" "$FILENAME"
done
