import 'package:didomi_sdk/didomi_sdk.dart';
import 'package:didomi_sdk/parameters/didomi_user_parameters.dart';
import 'package:didomi_sdk_example/widgets/base_sample_widget_state.dart';
import 'package:flutter/material.dart';

class SetUserWithContext extends StatefulWidget {
  const SetUserWithContext();

  @override
  State<SetUserWithContext> createState() => _SetUserWithContextState();
}

class _SetUserWithContextState
    extends BaseSampleWidgetState<SetUserWithContext> {
  @override
  String getActionId() => 'setUserWithContext';

  @override
  String getButtonName() => 'Set user with context';

  @override
  Future<String> callDidomiPlugin() async {
    final context = DidomiUserContext(
      attributes: {'plan': 'premium'},
      variables: {'segment': 'test'},
      age: 18,
      isLoggedIn: true,
    );
    final parameters = DidomiUserParameters(userContext: context);
    await DidomiSdk.setUserWithParameters(parameters);
    return 'OK';
  }
}
