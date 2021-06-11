#!/bin/bash

version=$(awk '/^version/{print $NF}' pubspec.yaml)
if [[ -z $version ]]; then
  echo "Error while getting flutter version"
  exit 1
fi

echo "$version"
