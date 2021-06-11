#!/bin/bash

#----------------------------------------------------------
# Loop UI test files in order to build and upload
# Scenarios to Firebase Test App
#----------------------------------------------------------

# Project settings
if [[ -z $1 ]]; then
  # Doesn't work anymore on github action?
  branchName=$(git rev-parse --abbrev-ref HEAD)
else
  branchName="$1"
fi

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
    --results-history-name "${branchName}_${fileName%%_test.dart}" || exit 1
done
