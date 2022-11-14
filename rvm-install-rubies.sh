#!/bin/bash

# NOTE: set -o pipefail is needed to ensure that any error or failure causes the whole pipeline to fail.
# Without this specification, the CI status will provide a false sense of security by showing builds
# as succeeding in spite of errors or failures.
set -eo pipefail

ARRAY_RUBY_VERSIONS=(<STR_RUBY_VERSIONS>)
ARRAY_BUNDLER_VERSIONS=(<STR_BUNDLER_VERSIONS>)
ARRAY_RAILS_VERSIONS=(<STR_RAILS_VERSIONS>)
ARRAY_PG_VERSIONS=(<STR_PG_VERSIONS>)
ARRAY_NOKOGIRI_VERSIONS=(<STR_NOKOGIRI_VERSIONS>)
ARRAY_FFI_VERSIONS=(<STR_FFI_VERSIONS>)

source ~/.rvm/scripts/rvm # Activate RVM

echo '--------------'
echo 'rvm get stable'
rvm get stable

echo '------------'
echo 'rvm get head'
rvm get head

echo '--------------'
echo 'rvm list known'
rvm list known 

# Install latest version of Ruby
echo '-------------------------'
echo 'rvm install ruby --latest'
rvm install ruby --latest

function install_gem_latest {
  GEM_NAME=$1
  echo '---------------------'
  echo "gem install $GEM_NAME"
  gem install $GEM_NAME
}

# Install a single gem version
function install_gem_version {
  GEM_NAME=$1
  GEM_VERSION=$2
  echo '-------------------------------------'
  echo "gem install $GEM_NAME -v $GEM_VERSION"
  gem install $GEM_NAME -v $GEM_VERSION
}

# Updates Rubygems
# Installs bundler
# Installs mailcatcher
# Installs the latest versions of rails, pg, nokogiri, and ffi
# Installs selected versions of rails, pg, nokogiri, and ffi
function install_all_gems {
  # Certain gems (such as rainbow) require that Rubygems be updated.
  # The default version of Rubygems may be incompatible with certain
  # gems, such as rainbow, rubocop, and annotate.
  echo '-------------------'
  echo 'gem update --system'
  gem update --system

  install_gem_latest 'mailcatcher'
  install_gem_latest 'bundler'
  install_gem_latest 'rails'
  install_gem_latest 'pg'
  install_gem_latest 'nokogiri'
  install_gem_latest 'ffi'

  for version in "${ARRAY_BUNDLER_VERSIONS[@]}"
  do
    install_gem_version 'bundler' $version
  done


  for version in "${ARRAY_RAILS_VERSIONS[@]}"
  do
    install_gem_version 'rails' $version
  done

  for version in "${ARRAY_PG_VERSIONS[@]}"
  do
    install_gem_version 'pg' $version
  done

  for version in "${ARRAY_NOKOGIRI_VERSIONS[@]}"
  do
    install_gem_version 'nokogiri' $version
  done

  for version in "${ARRAY_FFI_VERSIONS[@]}"
  do
    install_gem_version 'ffi' $version
  done
}

# Input parameter: 'ruby-x.y'
function install_ruby_version {
  ruby_version=$1
  echo '+++++++++++++++++++++++++++++++++++++'
  echo "BEGIN: time rvm install $ruby_version"
  echo '+++++++++++++++++++++++++++++++++++++'
  time rvm install $ruby_version
  wait
  echo ' /|\'
  echo '/ | \'
  echo '  |'
  echo "Time to install Ruby $ruby_version"
  echo '+++++++++++++++++++++++++++++++++++'
  echo "END: time rvm install $ruby_version"
  echo '+++++++++++++++++++++++++++++++++++'
  rvm use $ruby_version
  time install_all_gems
  wait
  echo ' /|\'
  echo '/ | \'
  echo '  |'
  echo 'Time to install all gems in'
  ruby -v
}

function time_install_ruby_version {
  RUBY_VERSION=$1
  time install_ruby_version $RUBY_VERSION
  echo ' /|\'
  echo '/ | \'
  echo '  |'
  echo "Time to install Ruby $RUBY_VERSION and gems"
  rvm use $RUBY_VERSION
} 

time install_all_gems

for ((i=${#ARRAY_RUBY_VERSIONS[@]}-1; i>=0; i--)); do
  time_install_ruby_version "${ARRAY_RUBY_VERSIONS[$i]}"
done

