import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:didomi_sdk/didomi_sdk.dart';

/// Widget to call DidomiSdk.shouldConsentBeCollected
class CheckConsent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CheckConsentState();
  }
}

class _CheckConsentState extends BaseSampleWidgetState<CheckConsent> {

  @override
  String getButtonName() {
    return "Check consent state";
  }

  @override
  String getActionId() {
    return "checkConsentState";
  }

  @override
  Future<String> callDidomiPlugin() async {
    // ignore: deprecated_member_use
    final bool consentRequired = await DidomiSdk.isConsentRequired;
    // ignore: deprecated_member_use
    final bool shouldConsentBeCollected = await DidomiSdk.shouldConsentBeCollected;
    final bool shouldUserStatusBeCollected = await DidomiSdk.shouldUserStatusBeCollected;
    // ignore: deprecated_member_use
    final bool consentStatusPartial = await DidomiSdk.isUserConsentStatusPartial;
    // ignore: deprecated_member_use
    final bool liStatusPartial = await DidomiSdk.isUserLegitimateInterestStatusPartial;
    final bool isUserStatusPartial = await DidomiSdk.isUserStatusPartial;
    return '\n- Is user consent required? $consentRequired\n'
        '- Should consent be collected? $shouldConsentBeCollected\n'
        '- Should User Status be collected? $shouldUserStatusBeCollected\n'
        '- Is status partial? consent => $consentStatusPartial, LI => $liStatusPartial\n'
        '- Is user status partial? $isUserStatusPartial';
  }
}
