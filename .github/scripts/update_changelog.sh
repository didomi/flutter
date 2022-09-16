#!/bin/bash

#----------------------------------------------------------
# Update Flutter Change log before publication
# Add new version to changelog with default message
#   No argument: failure
#----------------------------------------------------------

if [[ -z $1 ]]; then
  echo "flutter version is required"
  exit 1
else
  version="$1"
fi

target="CHANGELOG.md"
title="# Release Note"
message="- Update latest versions of native Android ($2) and iOS ($3) sdks"

replace="$title\n\n## $version\n$message"

sed -i~ -e "s/$title/$replace/gi" $target || exit 1
