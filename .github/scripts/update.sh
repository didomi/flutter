#!/bin/bash

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

# Get last version from pod
pod_last_version() {
  lastversion=""
  for line in $(pod trunk info Didomi-XCFramework); do
    if [[ "$line" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
      lastversion=$line
    fi
  done
  echo "$lastversion"
}

# Update Flutter version
flutterversion=""
version=$(awk '/^version/{print $NF}' pubspec.yaml)
flutterversion=$(increment_version "$version" $position)
if [[ -z $flutterversion ]]; then
  echo "Error while incrementing flutter version (from $version)"
  exit 1
fi

echo "Flutter version will change from $version to $flutterversion"

# Update android SDK Version
version=$(curl -s 'https://search.maven.org/solrsearch/select?q=didomi' | sed -n 's|.*"latestVersion":"\([^"]*\)".*|\1|p')
if [[ -z $version ]]; then
  echo "Error while getting android SDK version"
  exit 1
fi

echo "Android SDK last version is $version"

pushd android >/dev/null
sed -i~ -e "s|io.didomi.sdk:android:[0-9]\{1,2\}.[0-9]\{1,2\}.[0-9]\{1,2\}|io.didomi.sdk:android:$version|g" build.gradle || exit 1
sed -i~ -e "s|^version = \"[0-9]\{1,2\}.[0-9]\{1,2\}.[0-9]\{1,2\}\"|version = \"$flutterversion\"|g" build.gradle || exit 1
popd >/dev/null

# Update ios SDK Version
version=$(pod_last_version)
if [[ -z $version ]]; then
  echo "Error while getting ios SDK version"
  exit 1
fi

echo "iOS SDK last version is $version"

pushd ios >/dev/null
sed -i~ -e "s|s.dependency 'Didomi-XCFramework', '[0-9]\{1,2\}.[0-9]\{1,2\}.[0-9]\{1,2\}'|s.dependency 'Didomi-XCFramework', '$version'|g" didomi_sdk.podspec || exit 1
sed -i~ -e "s|s.version          = '[0-9]\{1,2\}.[0-9]\{1,2\}.[0-9]\{1,2\}'|s.version          = '$flutterversion'|g" didomi_sdk.podspec || exit 1
popd >/dev/null

# Update Flutter version
sed -i~ -e "s|version: [0-9]\{1,2\}.[0-9]\{1,2\}.[0-9]\{1,2\}|version: $flutterversion|g" pubspec.yaml || exit 1

# and reload dependencies
flutter pub get || exit 1

# Commit and push
git commit -m -a "Update dependencies and increment version name"
#git push
