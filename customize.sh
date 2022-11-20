#!/bin/bash

# NOTE: set -o pipefail is needed to ensure that any error or failure causes the whole pipeline to fail.
# Without this specification, the CI status will provide a false sense of security by showing builds
# as succeeding in spite of errors or failures.
set -eo pipefail

# This script customizes the Dockerfile and the scripts in usr_local_bin

source variables.sh

# Copying the original files
cp Dockerfile-orig Dockerfile
rm -rf usr_local_bin
cp -r usr_local_bin_orig usr_local_bin

# Renaming files in usr_local_bin
for FILENAME in 'usr_local_bin'/*; do
  STR1='abbrev'
  STR2="$ABBREV"
  FILE1="$FILENAME"
  FILE2=$(echo "$FILE1" | sed "s/$STR1/$STR2/")
  if [ "$FILE1" != "$FILE2" ]; then
    wait
    mv "$FILE1" "$FILE2"
    wait
  fi
done

replace_string_in_file () {
  STR1=$1
  STR2=$2
  FILENAME=$3
  sed -i "s/$STR1/$STR2/g" "$FILENAME"
}

replace_string_in_directory () {
  STR1=$1
  STR2=$2
  DIRECTORY=$3  
  find $DIRECTORY -type f -exec sed -i "s/$STR1/$STR2/g" {} +
}

# Customizing files
wait
replace_string_in_file '<OWNER>' "$OWNER" 'Dockerfile'
replace_string_in_file '<SUITE>' "$SUITE" 'Dockerfile'
replace_string_in_file '<ABBREV>' "$ABBREV" 'Dockerfile'
replace_string_in_file '<REGULAR_USER>' "$REGULAR_USER" 'Dockerfile'
wait
replace_string_in_directory '<SUITE>' "$SUITE" 'usr_local_bin'
replace_string_in_directory '<ABBREV>' "$ABBREV" 'usr_local_bin'
replace_string_in_directory '<REGULAR_USER>' "$REGULAR_USER" 'usr_local_bin'
wait
