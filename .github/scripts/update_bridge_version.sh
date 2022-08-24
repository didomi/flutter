#!/bin/bash

#---------------------------------------------------------------------------------------------
# Increment Flutter version (from param major|minor|patch)
#   No argument: use patch as default
# Update Change log by providing the new flutter version and the current native SDKs version
# Update flutter dependencies
#---------------------------------------------------------------------------------------------

# set nocasematch option
shopt -s nocasematch

# Increment position (Patch is default)
if [[ "$1" =~ ^major$ ]]; then
  position=0
elif [[ "$1" =~ ^minor$ ]]; then
  position=1
else
  position=2
fi

# unset nocasematch option
shopt -u nocasematch

# Increment version (eg `sh increment_version 1.2.3 1` returns `1.3.0`)
# args:
#   - version number (eg `0.32.4`)
#   - increment number: `0` (major) | `1` (minor) | `2` (patch)
increment_version() {
  local delimiter=.
  local array=($(echo "$1" | tr $delimiter '\n'))
  array[$2]=$((array[$2] + 1))
  if [ $2 -lt 2 ]; then array[2]=0; fi
  if [ $2 -lt 1 ]; then array[1]=0; fi
  echo $(
    local IFS=$delimiter
    echo "${array[*]}"
  )
}

# Get Flutter version
version=$(sh .github/scripts/extract_flutter_version.sh)
if [[ ! $version =~ ^[0-9]+.[0-9]+.[0-9]+$ ]]; then
  echo "Error while getting Flutter version"
  exit 1
fi

# Increment Flutter version
flutterversion=$(increment_version "$version" $position)
echo "Flutter version will change from $version to $flutterversion"

# Get current android SDK Version
pushd android >/dev/null
androidVersion=$(cat build.gradle | sed -n 's|.*"io.didomi.sdk:android:\([^"]*\)".*|\1|p')
popd >/dev/null
if [[ ! $androidVersion =~ ^[0-9]+.[0-9]+.[0-9]+$ ]]; then
  echo "Error while getting android SDK version ($androidVersion)"
  exit 1
fi

echo "Android SDK current version is $androidVersion"

# Get current ios SDK Version
pushd ios >/dev/null
iOSVersion=$(cat didomi_sdk.podspec | sed -n "s|.*'Didomi-XCFramework', '\([^']*\)'.*|\1|p")
popd >/dev/null
if [[ ! $iOSVersion =~ ^[0-9]+.[0-9]+.[0-9]+$ ]]; then
  echo "Error while getting ios SDK version ($iOSVersion)"
  exit 1
fi

echo "iOS SDK current version is $iOSVersion"

# Update Flutter version
sed -i~ -e "s|version: [0-9]\{1,2\}.[0-9]\{1,2\}.[0-9]\{1,2\}|version: $flutterversion|g" pubspec.yaml || exit 1

pushd android >/dev/null
sed -i~ -e "s|^version = \"[0-9]\{1,2\}.[0-9]\{1,2\}.[0-9]\{1,2\}\"|version = \"$flutterversion\"|g" build.gradle || exit 1
popd >/dev/null

pushd ios >/dev/null
sed -i~ -e "s|s.version          = '[0-9]\{1,2\}.[0-9]\{1,2\}.[0-9]\{1,2\}'|s.version          = '$flutterversion'|g" didomi_sdk.podspec || exit 1
popd >/dev/null

# Update changelog
sh .github/scripts/update_changelog.sh "$flutterversion" "$androidVersion" "$iOSVersion" || exit 1

# Cleanup backup files
find . -type f -name '*~' -delete

# Reload dependencies
flutter pub get || exit 1
