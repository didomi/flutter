#!/bin/bash

#----------------------------------------------------------
# Reset version for testing purpose to 0.0.0
# Flutter version, iOS and Android SDKs will updated
#----------------------------------------------------------

version="0.0.0"

pushd android >/dev/null
sed -i~ -e "s|io.didomi.sdk:android:[0-9]\{1,2\}.[0-9]\{1,2\}.[0-9]\{1,2\}|io.didomi.sdk:android:$version|g" build.gradle || exit 1
sed -i~ -e "s|^version = \"[0-9]\{1,2\}.[0-9]\{1,2\}.[0-9]\{1,2\}\"|version = \"$version\"|g" build.gradle || exit 1
popd >/dev/null

pushd ios >/dev/null
sed -i~ -e "s|s.dependency 'Didomi-XCFramework', '[0-9]\{1,2\}.[0-9]\{1,2\}.[0-9]\{1,2\}'|s.dependency 'Didomi-XCFramework', '$version'|g" didomi_sdk.podspec || exit 1
sed -i~ -e "s|s.version          = '[0-9]\{1,2\}.[0-9]\{1,2\}.[0-9]\{1,2\}'|s.version          = '$version'|g" didomi_sdk.podspec || exit 1
popd >/dev/null

# Reset Flutter version
sed -i~ -e "s|version: [0-9]\{1,2\}.[0-9]\{1,2\}.[0-9]\{1,2\}|version: $version|g" pubspec.yaml || exit 1
pushd lib/assets >/dev/null
sed -i~ -e "s|\"plugin_version\": \"[0-9]\{1,2\}.[0-9]\{1,2\}.[0-9]\{1,2\}\"|\"plugin_version\": \"$version\"|g" plugin_info.json || exit 1
popd >/dev/null
