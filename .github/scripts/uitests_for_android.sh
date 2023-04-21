#!/bin/bash

#----------------------------------------------------------
# Launch UI tests for Android
#----------------------------------------------------------

# Search for device name
DEVICE=$(emulator -list-avds | head -n 1)

echo "$DEVICE"

# (re)Launch emulator
adb -s emulator-5554 emu kill
emulator "@$DEVICE" -no-window -wipe-data &
#emulator "@$DEVICE" &

# Wait for emulator to start
sleep 30

# Move to sample folder
cd ./example || exit 1

# Cleanup workspace
flutter clean || exit 1

# Delete logs (for local usage)
rm machine.log

# Run tests and print logs
flutter test --machine -d emulator-5554 -r expanded integration_test >machine.log || exit 1

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
