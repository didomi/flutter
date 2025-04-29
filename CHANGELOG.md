# Release Note

## 2.11.0
- Update latest versions of native Android (2.24.0) and iOS (2.24.0) sdks

## 2.10.1
- Update latest versions of native Android (2.19.1) and iOS (2.19.1) sdks

## 2.10.0
- Update latest versions of native Android (2.19.0) and iOS (2.19.0) sdks
- Implement new public function `initializeWithParameters()`.
- Implement new public functions `setUserWithParameters()` and `setUserWithParametersAndSetupUI()`.

## 2.9.0
- Update latest versions of native Android (2.18.0) and iOS (2.18.0) sdks
- Deprecate methods and parameters related to SPI purposes
- Implement new public computed property `applicableRegulation`.

## 2.8.0
- Update latest versions of native Android (2.17.0) and iOS (2.17.0) sdks
- Handle `organizationUserId` field in SyncReadyEvent 
- Android: Add `jvmTarget` in `build.gradle` `kotlinOptions`

## 2.7.0
- Update latest versions of native Android (2.10.1) and iOS (2.11.1) sdks
- Add support for vendor count methods

## 2.6.0
- Update latest versions of native Android (2.10.0) and iOS (2.11.0) sdks

## 2.5.0
- Update latest versions of native Android (2.9.0) and iOS (2.9.2) sdks

## 2.4.0
- Update latest versions of native Android (2.7.0) and iOS (2.8.0) sdks
- Update Android's build configuration (required for Flutter 3.22)
  - :warning: **Compiling for Android will now require Flutter `3.16.0` or higher**

## 2.3.0
- Update latest versions of native Android (2.6.0) and iOS (2.7.0) sdks
- Add support for `SyncReady` event
- Add new parameters to the `initialize` method to override the user location determined by the SDK when getting the notice configuration:
  - `countryCode`: Force the user country used to get the notice configuration
  - `regionCode`: Force the user region used to get the notice configuration
- Stop force unwrapping when getting the root view controller

## 2.2.0
- Update latest versions of native Android (2.4.0) and iOS (2.4.0) sdks
- Implement new public function `openCurrentUserStatusTransaction()`.

## 2.1.0
- Update latest versions of native Android (2.2.0) and iOS (2.2.0) sdks
- Support new methods `addVendorStatusListener` and `removeVendorStatusListener`
- Update Kotlin version from `1.7.20` to `1.8.20`

## 2.0.1
- Update latest versions of native Android (2.0.1) and iOS (2.0.2) sdks
- Fix event handler for `onPreferencesClickDisagreeToAll`

## 2.0.0
- Update latest versions of native Android (2.0.0) and iOS (2.0.1) sdks
- Remove deprecated methods (breaking changes)
  - `disabledPurposeIds`
  - `disabledPurposes`
  - `disabledVendorIds`
  - `disabledVendors`
  - `enabledPurposeIds`
  - `enabledPurposes`
  - `enabledVendorIds`
  - `enabledVendors`
  - `initialize` (without DidomiInitializeParameters)
  - `setUserWithAuthentication` (with authentication parameters instead of UserAuthParams)
  - `getUserConsentStatusForPurpose`
  - `getUserConsentStatusForVendor`
  - `getUserConsentStatusForVendorAndRequiredPurposes`
  - `getUserLegitimateInterestStatusForPurpose`
  - `getUserLegitimateInterestStatusForVendor`
  - `getUserLegitimateInterestStatusForVendorAndRequiredPurposes`
  - `getUserStatusForVendor`
- Refactor `Purpose` and `Vendor` objects (breaking changes)

## 1.21.0
- Update latest versions of native Android (1.90.0) and iOS (1.99.0) sdks

## 1.20.0
- Update latest versions of native Android (1.89.0) and iOS (1.98.0) sdks
- Implement new public function `getCurrentUserStatus()`.
- Implement new public function `setCurrentUserStatus()`.

## 1.19.0
- Update latest versions of native Android (1.88.0) and iOS (1.97.0) sdks
- Implement new public function `isUserStatusPartial()`.
- Implement new public function `shouldUserStatusBeCollected()`.

## 1.18.0
- Update latest versions of native Android (1.87.0) and iOS (1.96.0) sdks

## 1.17.0
- Update latest versions of native Android (1.86.1) and iOS (1.95.1) sdks

## 1.16.0
- Update latest versions of native Android (1.86.0) and iOS (1.95.0) sdks

## 1.15.0
- Update latest versions of native Android (1.85.0) and iOS (1.94.0) sdks
- Apply fix to avoid error `channel sent a message from native to Flutter on a non-platform thread`

## 1.14.0
- Update latest versions of native Android (1.84.1) and iOS (1.93.1) sdks

## 1.13.0
- Update latest versions of native Android (1.83.0) and iOS (1.92.0) sdks

## 1.12.0
- Update latest versions of native Android (1.81.0) and iOS (1.90.0) sdks

## 1.11.0
- Update latest versions of native Android (1.80.0) and iOS (1.89.1) sdks

## 1.10.0
- Update latest versions of native Android (1.78.0) and iOS (1.88.0) sdks

## 1.9.0
- Update latest versions of native Android (1.77.0) and iOS (1.87.0) sdks
- Add `CPRA` regulation support
- Implement new internal events for `Sensitive Personal Information` interactions

## 1.8.0
- Update latest versions of native Android (1.76.0) and iOS (1.86.0) sdks
- Throw error log (iOS) / Exception (Android) when calling `clearUser` before SDK initialization

## 1.7.0
- Update latest versions of native Android (1.70.1) and iOS (1.79.1) sdks
- Update Android Build Config (Kotlin version 1.7.20)

## 1.6.0
- Update latest versions of native Android (1.69.0) and iOS (1.78.0) sdks
- Add `CCPA` regulation support

## 1.5.0
- Update latest versions of native Android (1.66.0) and iOS (1.75.0) sdks
- Add AndroidTV support

## 1.4.0
- Update latest versions of native Android and iOS sdks
- Add `languageUpdated` / `languageUpdateFailed` events from native sdks

## 1.3.0
- Update latest versions of native Android and iOS sdks
- Add `setUserWithAuthParams` feature (replaces deprecated `setUserWithAuthentication`)

## 1.2.0
- Update latest versions of native Android and iOS sdks
- Support new IAB rules regarding timestamp in the GDPR consent string: See https://github.com/InteractiveAdvertisingBureau/GDPR-Transparency-and-Consent-Framework/pull/306/files#diff-99d4d9da93e17e584b04a239a04503a776d54503b0e2db52fc157b77fc950bbbR65
  - The timestamps have now only day-level granularity.
  - `Created` field has the same value as `LastUpdated`
- Fully support `showPreferences` / `hidePreferences` events
  
## 1.1.0
- Update Android / iOS native sdks
- Add `showPreferences` / `hidePreferences` events from native sdks

## 1.0.1
- Fix git repository to allow publication

## 1.0.0
- Update Android / iOS native sdks
- Add getUserStatus feature from native sdks

## 0.0.1-alpha.1
- Internal release that add missing features from native sdks

## 0.0.1-dev.1
- Initial release that contains essential methods required for implementing the Didomi Flutter SDK on a Flutter app.
