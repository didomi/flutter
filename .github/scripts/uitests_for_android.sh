#!/bin/bash

#----------------------------------------------------------
# Launch UI tests for Android
#----------------------------------------------------------

# Set up environment variables for Mac Mini M2
export ANDROID_SDK_ROOT=/Users/administrator/Library/Android/sdk
export PATH=$PATH:$ANDROID_SDK_ROOT/emulator
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
export PATH=$PATH:$ANDROID_SDK_ROOT/tools
export PATH=$PATH:$ANDROID_SDK_ROOT/tools/bin

# Search for device name
DEVICE="Medium_Phone_API_31"

echo "$DEVICE"

# (re)Launch emulator
adb -s emulator-5554 emu kill
~/Library/Android/sdk/emulator/emulator "@$DEVICE" -no-window -wipe-data &

# Wait for emulator to start
sleep 30

# Move to sample folder
cd ./example || exit 1

# Cleanup workspace
flutter clean || exit 1

# Delete logs if exists (for local usage)
if [ -f machine.log ]; then
  rm machine.log
fi

# Run tests and print logs
flutter test --machine -d emulator-5554 -r expanded integration_test >machine.log

# Shutdown emulator
adb -s emulator-5554 emu kill

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
