#!/bin/bash

# NOTE: set -o pipefail is needed to ensure that any error or failure causes the whole pipeline to fail.
# Without this specification, the CI status will provide a false sense of security by showing builds
# as succeeding in spite of errors or failures.
set -eo pipefail

STRING1="$1"
STRING2="$2"
DIR_NAME="$3"

# This script recursively replaces a string with another string for all files in a given directory.

# NOTE: from
# https://www.warp.dev/terminus/bash-loop-through-files-in-directory#looping-through-files-recursively
function iterate() {
  DIR1="$1"

  for FILE in "$DIR1"/*; do
    if [ -f "$FILE" ]; then
      wget -q -O - \
      https://raw.githubusercontent.com/rubyonracetracks/docker-common/main/replace-string-in-file.sh \
      | bash -s "$STRING1" "$STRING2" "$FILE" > /dev/null
    fi

    if [ -d "$FILE" ]; then
      iterate "$FILE"
    fi
  done
}

iterate "$DIR_NAME"
