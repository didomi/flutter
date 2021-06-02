#!/bin/sh

# Project settings
branchName=$(git rev-parse --abbrev-ref HEAD)

# iOS Settings
output="../build/ios_integ"
product="build/ios_integ/Build/Products"
dev_target="14.5"

# Move to sample folder
cd ./example || exit 1

# Compute UI tests scenarios
for file in $(find integration_test -maxdepth 1 -type f); do
  # Extract file name from path
  fileName=$(echo "$file" | cut -d"/" -f 2)

  echo "--------------------------------------------------------"
  echo "| Scenario (file): $fileName ($file)"
  echo "| Git branch: $branchName"
  echo "--------------------------------------------------------"

  echo "--------------------------------------------------------"
  echo "| Building $fileName Test App for Android"
  echo "--------------------------------------------------------"

  # Build apk file for Android
  pushd android
  # flutter build generates files in android/ for building the app
  flutter build apk
  ./gradlew app:assembleAndroidTest
  ./gradlew app:assembleDebug -Ptarget="$file"
  popd

  echo "--------------------------------------------------------"
  echo "| Publishing $fileName to Firebase  for Android"
  echo "--------------------------------------------------------"

  # Upload apk to firebase
  gcloud firebase test android run --type instrumentation \
    --app build/app/outputs/apk/debug/app-debug.apk \
    --test build/app/outputs/apk/androidTest/debug/app-debug-androidTest.apk \
    --use-orchestrator \
    --timeout 30m \
    --num-flaky-test-attempts 3 \
    --results-history-name "${branchName}_and_${fileName%%_test.dart}"

  echo "--------------------------------------------------------"
  echo "| Building $fileName Test App for iOS"
  echo "--------------------------------------------------------"

  # Build zip file for iOS
  flutter build ios "$file" --release

  pushd ios
  xcodebuild -workspace Runner.xcworkspace -scheme Runner -config Flutter/Release.xcconfig -derivedDataPath $output -sdk iphoneos build-for-testing
  popd

  pushd $product
  zip -r "ios_tests.zip" "Release-iphoneos" "Runner_iphoneos$dev_target-arm64-armv7.xctestrun"
  popd

  echo "--------------------------------------------------------"
  echo "| Publishing $fileName to Firebase for iOS"
  echo "--------------------------------------------------------"

  # Upload zip to firebase
  gcloud firebase test ios run --test "$product/ios_tests.zip" \
    --device model=iphone8,version=14.1,locale=fr_FR,orientation=portrait \
    --timeout 30m \
    --num-flaky-test-attempts 3 \
    --results-history-name "${branchName}_ios_${fileName%%_test.dart}"

  # TODO - Remove this
  exit 0
done
