#!/bin/bash

version=$(awk '/^version/{print $NF}' pubspec.yaml)
if [[ -z $version ]]; then
  echo "Error while getting flutter version"
  exit 1
fi

# Create tag from version
#git tag "$version" || exit 1

# Push changes and tag
#git push --follow-tags || exit 1
