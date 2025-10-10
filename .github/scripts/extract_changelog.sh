#!/bin/bash

#----------------------------------------------------------
# Extract changelog for a specific version from CHANGELOG.md
# Usage: extract_changelog.sh <version>
# Example: extract_changelog.sh 2.15.0
# Returns the changelog content for the specified version
#----------------------------------------------------------

version=$1

if [ -z "$version" ]; then
  echo "Error: version parameter is required"
  exit 1
fi

if [ ! -f "CHANGELOG.md" ]; then
  echo "Error: CHANGELOG.md file not found"
  exit 1
fi

# Extract the changelog section for the specified version
changelog=$(awk -v version="$version" '
  /^## / {
    if (found) exit;
    if ($2 == version) {
      found=1;
      next;
    }
  }
  found {print}
' CHANGELOG.md)

if [ -z "$changelog" ]; then
  echo "Error: No changelog found for version $version"
  exit 1
fi

echo "$changelog"
