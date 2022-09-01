#!/bin/bash

#----------------------------------------------------------
# Loop UI test files in order to build and upload
# Scenarios to Firebase Test App
#----------------------------------------------------------

# Project settings
if [[ -z $1 ]]; then
  # From Local - Doesn't work anymore on github action?
  branchName=$(git rev-parse --abbrev-ref HEAD)
  # Cleanup workspace
  flutter clean || exit 1
else
  # From CI
  branchName="$1"
fi

# iOS Settings
output="../build/ios_integ"
product="build/ios_integ/Build/Products"
dev_target="15.5"

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
  echo "| Building $fileName Test App for iOS"
  echo "--------------------------------------------------------"

  # Build zip file for iOS
  # Pass --simulator if building for the simulator.
  flutter build ios "$file" --release || exit 1

  echo "--------------------------------------------------------"
  echo "| Xcodebuild $fileName Test App for iOS"
  echo "--------------------------------------------------------"

  pushd ios
  xcodebuild -workspace Runner.xcworkspace -scheme Runner -config Flutter/Release.xcconfig -derivedDataPath $output -sdk iphoneos build-for-testing || exit 1
  popd

  echo "--------------------------------------------------------"
  echo "| Building $fileName zip file for iOS"
  echo "--------------------------------------------------------"

  pushd $product
  zip -r "ios_tests.zip" "Release-iphoneos" "Runner_iphoneos$dev_target-arm64.xctestrun"
  popd

#  echo "--------------------------------------------------------"
#  echo "| Running $fileName locally" requires --simulator on build
#  echo "--------------------------------------------------------"
#
#  xcodebuild test-without-building -xctestrun "$product/Runner_iphoneos$dev_target-arm64.xctestrun" -destination id=<DEVICE_ID>

  echo "--------------------------------------------------------"
  echo "| Publishing $fileName to Firebase for iOS"
  echo "--------------------------------------------------------"

  # Upload zip to firebase
  gcloud firebase test ios run --test "$product/ios_tests.zip" \
    --device model=iphone8,version=14.7,locale=en_US,orientation=portrait \
    --timeout 30m \
    --num-flaky-test-attempts 3 \
    --results-history-name "${branchName}_${fileName%%_test.dart}" || exit 1
done
