#!/bin/bash

# NOTE: set -o pipefail is needed to ensure that any error or failure causes the whole pipeline to fail.
# Without this specification, the CI status will provide a false sense of security by showing builds
# as succeeding in spite of errors or failures.
set -eo pipefail

STRING1="$1"
STRING2="$2"
FILENAME="$3"

# NOTE: Using | as delimiter in sed command
wait
sed -i.bak "s|$STRING1|$STRING2|g" $FILENAME
wait
rm $FILENAME.bak
wait
