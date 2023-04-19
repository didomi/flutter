#!/bin/bash

#----------------------------------------------------------
# Loop UI test files and run each scenario individually
#
# Running all scenarios on Github Action runner does fail
# So we need to launch each scenario individually
#----------------------------------------------------------

if [[ -z $1 ]]; then
  echo "You must provide a device name"
  exit 1
else
  device="$1"
fi

# Move to sample folder
cd ./example || exit 1

# Compute UI tests scenarios
for file in $(find integration_test -maxdepth 1 -type f); do
  # Extract file name from path
  fileName=$(echo "$file" | cut -d"/" -f 2)

  echo "--------------------------------------------------------"
  echo "| Scenario (file): $fileName"
  echo "--------------------------------------------------------"

  flutter test --machine -d "$device" "$file" || exit 1
done
