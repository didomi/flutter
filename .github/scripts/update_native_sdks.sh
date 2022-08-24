#!/bin/bash

#----------------------------------------------------------
# Update Android and iOS SDKs version (latest from repos)
#----------------------------------------------------------

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

# Update android SDK Version
androidVersion=$(curl -s 'https://search.maven.org/solrsearch/select?q=didomi' | sed -n 's|.*"latestVersion":"\([^"]*\)".*|\1|p')
if [[ ! $androidVersion =~ ^[0-9]+.[0-9]+.[0-9]+$ ]]; then
  echo "Error while getting android SDK version ($androidVersion)"
  exit 1
fi

echo "Android SDK last version is $androidVersion"

pushd android >/dev/null
sed -i~ -e "s|io.didomi.sdk:android:[0-9]\{1,2\}.[0-9]\{1,2\}.[0-9]\{1,2\}|io.didomi.sdk:android:$androidVersion|g" build.gradle || exit 1
popd >/dev/null

# Update ios SDK Version
iOSVersion=$(pod_last_version)
if [[ ! $iOSVersion =~ ^[0-9]+.[0-9]+.[0-9]+$ ]]; then
  echo "Error while getting ios SDK version ($iOSVersion)"
  exit 1
fi

echo "iOS SDK last version is $iOSVersion"

pushd ios >/dev/null
sed -i~ -e "s|s.dependency       'Didomi-XCFramework', '[0-9]\{1,2\}.[0-9]\{1,2\}.[0-9]\{1,2\}'|s.dependency       'Didomi-XCFramework', '$iOSVersion'|g" didomi_sdk.podspec || exit 1
popd >/dev/null

pushd example/ios >/dev/null
pod repo update || exit 1
pod update || exit 1
popd >/dev/null

# Reload dependencies
flutter pub get || exit 1
