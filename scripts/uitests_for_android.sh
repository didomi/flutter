#!/bin/bash

# Project settings
branchName=$(git rev-parse --abbrev-ref HEAD)

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
  ./gradlew app:assembleAndroidTest || exit 1
  ./gradlew app:assembleDebug -Ptarget="$file" || exit 1
  popd

#  echo "--------------------------------------------------------"
#  echo "| Publishing $fileName to Firebase  for Android"
#  echo "--------------------------------------------------------"
#
#  # Upload apk to firebase
#  gcloud firebase test android run --type instrumentation \
#    --app build/app/outputs/apk/debug/app-debug.apk \
#    --test build/app/outputs/apk/androidTest/debug/app-debug-androidTest.apk \
#    --use-orchestrator \
#    --timeout 30m \
#    --num-flaky-test-attempts 3 \
#    --results-history-name "${branchName}_and_${fileName%%_test.dart}" || exit 1
done
