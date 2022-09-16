# Release Note

## 1.6.0
Update latest versions of native Android (1.69.0) and iOS (1.78.0) sdks
Add CCPA regulation support

## 1.5.0
Update latest versions of native Android (1.66.0) and iOS (1.75.0) sdks
Add AndroidTV support

## 1.4.0
Update latest versions of native Android and iOS sdks
Add `languageUpdated` / `languageUpdateFailed` events from native sdks

## 1.3.0
Update latest versions of native Android and iOS sdks
Add `setUserWithAuthParams` feature (replaces deprecated `setUserWithAuthentication`)

## 1.2.0
Update latest versions of native Android and iOS sdks
Support new IAB rules regarding timestamp in the GDPR consent string: See https://github.com/InteractiveAdvertisingBureau/GDPR-Transparency-and-Consent-Framework/pull/306/files#diff-99d4d9da93e17e584b04a239a04503a776d54503b0e2db52fc157b77fc950bbbR65
- The timestamps have now only day-level granularity.
- `Created` field has the same value as `LastUpdated`
Fully support `showPreferences` / `hidePreferences` events
  
## 1.1.0
Update Android / iOS native sdks
Add `showPreferences` / `hidePreferences` events from native sdks

## 1.0.1
Fix git repository to allow publication

## 1.0.0
Update Android / iOS native sdks
Add getUserStatus feature from native sdks

## 0.0.1-alpha.1
Internal release that add missing features from native sdks

## 0.0.1-dev.1
Initial release that contains essential methods required for implementing the Didomi Flutter SDK on a Flutter app.
