import 'package:didomi_sdk/parameters/didomi_user_context.dart';
import 'package:didomi_sdk/parameters/user_auth_params.dart';

export 'package:didomi_sdk/parameters/didomi_user_context.dart';

/// User parameters for Didomi SDK
class DidomiUserParameters {
  /// Main user authentication
  UserAuth? userAuth;

  /// User authentication for Didomi Consent String
  UserAuthParams? dcsUserAuth;

  /// Whether the user is underage (null will keep the setting from initialization or from a previous call to `setUser`)
  bool? isUnderage;

  /// Optional context forwarded with this user.
  DidomiUserContext? userContext;

  DidomiUserParameters(
      {this.userAuth, this.dcsUserAuth, this.isUnderage, this.userContext});

  Map<String, dynamic> toJson() {
    final auth = userAuth;
    final context = userContext;
    return {
      if (auth != null) 'userAuth': auth.toJson(),
      'dcsUserAuth': dcsUserAuth?.toJson(),
      'isUnderage': isUnderage,
      if (context != null) 'userContext': context.toJson(),
    };
  }
}

/// Multi-User parameters for Didomi SDK
class DidomiMultiUserParameters extends DidomiUserParameters {
  /// Synchronized user array
  List<UserAuthParams>? synchronizedUsers;

  DidomiMultiUserParameters(
      {UserAuth? userAuth,
      UserAuthParams? dcsUserAuth,
      this.synchronizedUsers,
      bool? isUnderage,
      DidomiUserContext? userContext})
      : super(
            userAuth: userAuth,
            dcsUserAuth: dcsUserAuth,
            isUnderage: isUnderage,
            userContext: userContext);

  @override
  Map<String, dynamic> toJson() {
    var map = super.toJson();
    map.addAll({
      'synchronizedUsers':
          synchronizedUsers?.map((user) => user.toJson()).toList(),
    });
    return map;
  }
}
