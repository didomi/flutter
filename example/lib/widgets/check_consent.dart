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
    final bool consentRequired = await DidomiSdk.isConsentRequired;
    final bool shouldConsentBeCollected = await DidomiSdk.shouldConsentBeCollected;
    final bool consentStatusPartial = await DidomiSdk.isUserConsentStatusPartial;
    final bool liStatusPartial = await DidomiSdk.isUserLegitimateInterestStatusPartial;
    final bool isUserStatusPartial = await DidomiSdk.isUserStatusPartial;
    return '\n- Is user consent required? $consentRequired\n'
        '- Should consent be collected? $shouldConsentBeCollected\n'
        '- Is status partial? consent => $consentStatusPartial, LI => $liStatusPartial\n'
        '- Is user status partial? $isUserStatusPartial';
  }
}
