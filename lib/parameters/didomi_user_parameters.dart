import 'package:didomi_sdk/parameters/user_auth_params.dart';

/// User parameters for Didomi SDK
class DidomiUserParameters {
  /// Main user authentication
  UserAuth userAuth;

  /// User authentication for Didomi Consent String
  UserAuthParams? dcsUserAuth;

  /// Whether the user is underage (null will keep the setting from initialization or from a previous call to `setUser`)
  bool? isUnderage;

  DidomiUserParameters({required this.userAuth, this.dcsUserAuth = null, this.isUnderage = null});

  Map<String, dynamic> toJson() => {
        'userAuth': userAuth.toJson(),
        'dcsUserAuth': dcsUserAuth?.toJson(),
        'isUnderage': isUnderage,
      };
}

/// Multi-User parameters for Didomi SDK
class DidomiMultiUserParameters extends DidomiUserParameters {
  /// Synchronized user array
  List<UserAuthParams>? synchronizedUsers;

  DidomiMultiUserParameters(
      {required UserAuth userAuth,
      UserAuthParams? dcsUserAuth = null,
      this.synchronizedUsers = null,
      bool? isUnderage = null})
      : super(userAuth: userAuth, dcsUserAuth: dcsUserAuth, isUnderage: isUnderage);

  @override
  Map<String, dynamic> toJson() {
    var map = super.toJson();
    map.addAll({
      'synchronizedUsers': synchronizedUsers?.map((user) => user.toJson()).toList(),
    });
    return map;
  }
}
