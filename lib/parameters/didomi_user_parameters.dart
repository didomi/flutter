import 'package:didomi_sdk/parameters/user_auth_params.dart';

/// User parameters for Didomi SDK
class DidomiUserParameters {
  /// Main user authentication
  UserAuth userAuth;

  /// User authentication for Didomi Consent String
  UserAuthParams? dcsUserAuth;

  /// Whether the user is underage (null will keep the setting from initialization or from a previous call to `setUser`)
  bool? isUnderage;

  DidomiUserParameters(this.userAuth, this.dcsUserAuth, this.isUnderage);

  Map<String, dynamic> toJson() {
    return {
      'userAuth': userAuth.toJson(),
      'dcsUserAuth': dcsUserAuth?.toJson(),
      'isUnderage': isUnderage,
    };
  }
}

/// Multi-User parameters for Didomi SDK
class DidomiMultiUserParameters extends DidomiUserParameters {
  /// Synchronized user array
  List<UserAuthParams>? synchronizedUsers;

  DidomiMultiUserParameters(UserAuth userAuth, UserAuthParams? dcsUserAuth, this.synchronizedUsers, bool? isUnderage)
      : super(userAuth, dcsUserAuth, isUnderage);

  @override
  Map<String, dynamic> toJson() {
    var map = super.toJson();
    map.addAll({
      'synchronizedUsers': synchronizedUsers?.map((user) => user.toJson()).toList(),
    });
    return map;
  }
}
