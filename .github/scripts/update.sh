#!/bin/bash

#---------------------------------------------------------------------------------------------
# Update Android and iOS SDKs version (latest from repos)
# THEN
# Increment Flutter version (from param major|minor|patch)
#   No argument: use patch as default
# Update Change log by providing the new flutter version and the current native SDKs version
# Update flutter dependencies
#---------------------------------------------------------------------------------------------

sh .github/scripts/update_native_sdks.sh || exit 1
sh .github/scripts/update_bridge_version.sh "$1" || exit 1
