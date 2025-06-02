#!/bin/bash

#----------------------------------------------------------
# Launch UI tests for Android
#----------------------------------------------------------

# Get current user ('administrator' for the CI)
USER=$(whoami)

if [[ $USER == "administrator" ]]; then
  # Set up environment variables for Mac Mini M2
  export ANDROID_SDK_ROOT=/Users/administrator/Library/Android/sdk
  export PATH=$PATH:$ANDROID_SDK_ROOT/emulator
  export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
  export PATH=$PATH:$ANDROID_SDK_ROOT/tools
  export PATH=$PATH:$ANDROID_SDK_ROOT/tools/bin

  # Use specific name
  DEVICE="Medium_Phone_API_31"
else
  # Search for device name
  DEVICE=$(emulator -list-avds | head -n 1)
fi

echo "Using $DEVICE"

# (re)Launch emulator
adb devices | grep emulator | cut -f1 | while read -r line; do adb -s "$line" emu kill; done
emulator -avd "$DEVICE" -grpc 8554 -no-window -read-only -no-snapshot-load -no-snapshot-save &

# Move to sample folder
cd ./example || exit 1

# Cleanup workspace
flutter clean || exit 1

# Delete logs if exists (for local usage)
if [ -f machine.log ]; then
  rm machine.log
fi

# Wait 60 seconds to make sure emulator is started
sleep 60

# Run tests and print logs
EMULATOR_ID=$(adb devices | grep emulator | cut -f1)
flutter test --machine -d "$EMULATOR_ID" -r expanded integration_test | tee machine.log

# Shutdown emulator(s)
adb devices | grep emulator | cut -f1 | while read -r line; do adb -s "$line" emu kill; done

# Extract log information
RESULT="$(tail -n1 'machine.log')"
SUCCESS="$(echo "$RESULT" | jq -r '.success')"
TIME="$(echo "$RESULT" | jq -r '.time')"
TIME=$((TIME / 1000))

if [[ ${SUCCESS} != "true" ]]; then
  echo "Tests FAILED in $((TIME / 60)) minutes $((TIME % 60)) seconds"
  exit 1
else
  echo "Tests SUCCEEDED in $((TIME / 60)) minutes $((TIME % 60)) seconds"
  exit 0
fi
