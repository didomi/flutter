Didomi Flutter Plugin
==============================

[Didomi](https://www.didomi.io) is a leading Consent Management Platform that allows companies to collect, store, and leverage user consent under GDPR, CCPA, and other data privacy regulations. This plugin enables Flutter developers to get in compliance and optimize their consent rate and monetization on native mobile apps.

This repository contains the source code and a sample app for the [Didomi](https://www.didomi.io) Flutter
plugin. This plugin enables Flutter developers to easily use [Didomi](https://www.didomi.io)'s Consent Management Platform on Android and iOS apps.  
The plugin provides an interface for collecting consent that is used by your dart code.

# Installation

## Downloads

Check out our [releases](https://github.com/didomi/flutter/releases) for the latest official version of the plugin.

## Documentation

For instructions on installing and using the plugin, please read our documentation:

- [Developer guide](https://developers.didomi.io/cmp/flutter).
- [API reference](https://developers.didomi.io/cmp/flutter/reference)

# Sample app

Clone this repository and open the `example/` folder.

## Integration tests

All test scenarios are located in `example/integration_test/`

### Using Flutter Bridge
```
cd ./example

flutter drive \
    --driver=test_driver/integration_test.dart \
    --target=integration_test/<FILENAME>.dart
```

### Using Espresso (Android)
```
cd ./example/android/

// Single test
./gradlew app:connectedAndroidTest -Ptarget=`pwd`/../integration_test/<FILENAME>.dart

// Bulk test
.gradlew bulk
```

### Using XCTest (iOS)
```
cd ./example/

xcodebuild -workspace ios/Runner.xcworkspace -scheme "RunnerTests" -enableCodeCoverage YES -destination "platform=iOS Simulator,name=iPhone 8,OS=14.5" test
```

# Suggesting improvements

To file bugs, make feature requests, or to suggest other improvements,
please use [Github's issue tracker](https:////github.com/didomi/flutter/issues).

# License

This plugin is [released under the LGPL 3.0 license](LICENSE).

