#!/bin/bash

#----------------------------------------------------------
# Launch UI tests for iOS
#----------------------------------------------------------

# Search for device ID
DEVICE=$(xcrun simctl list devices | grep -m 1 'iPhone 16' | grep -E -o -i '([0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12})')

# (re)Launch simulator
xcrun simctl shutdown "${DEVICE}"
xcrun simctl boot "${DEVICE}" || exit 1

# Move to sample folder
cd ./example || exit 1

# Cleanup workspace
flutter clean || exit 1

# Run tests and print logs
flutter test --machine -d "${DEVICE}" -r expanded integration_test >machine.log

# Shutdown simulator
xcrun simctl shutdown "${DEVICE}"

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
fi
