#!/bin/bash

#----------------------------------------------------------
# Extract Flutter version (eg: 1.2.3)
# Returns the flutter current version if match pattern
#----------------------------------------------------------

version=$(awk '/^version/{print $NF}' pubspec.yaml)
if [[ ! $version =~ ^[0-9]+.[0-9]+.[0-9]+$ ]]; then
  echo "Error while getting flutter version"
  exit 1
fi

echo "$version"
