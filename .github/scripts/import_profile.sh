#!/bin/bash

set -euo pipefail

uuid=$($(uuidgen) | tr '[:upper:]' '[:lower:]')

mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
echo "$PROVISIONING_PROFILE_DATA" | base64 --decode > ~/Library/MobileDevice/Provisioning\ Profiles/"$uuid.mobileprovision"
