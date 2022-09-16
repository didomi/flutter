#!/bin/bash

#----------------------------------------------------------
# Extract Android SDK version (eg: 1.2.3)
# Returns the Android SDK current version if match pattern
#----------------------------------------------------------

version=$(cat android/build.gradle | sed -n 's|.*io.didomi.sdk:android:\([^"]*\)".*|\1|p')
if [[ ! $version =~ ^[0-9]+.[0-9]+.[0-9]+$ ]]; then
  echo "Error while getting flutter version"
  exit 1
fi

echo "$version"
