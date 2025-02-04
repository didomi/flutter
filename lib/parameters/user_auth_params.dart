abstract class UserAuth {
  /// Organization User ID
  String id;

  UserAuth(this.id);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
    };
  }
}

abstract class UserAuthParams extends UserAuth {
  /// Algorithm used for computing the OUID
  String algorithm;

  /// ID of the secret used for computing the OUID
  String secretId;

  /// Expiration date as timestamp (to prevent replay attacks)
  int? expiration;

  UserAuthParams(String id, this.algorithm, this.secretId, this.expiration) : super(id);

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'algorithm': algorithm,
      'secretId': secretId,
      'expiration': expiration,
    };
  }
}

/// User Authentication Parameters with encryption
class UserAuthWithEncryptionParams extends UserAuthParams {
  /// Initialization Vector used for computing the OUID
  String initializationVector;

  UserAuthWithEncryptionParams(String id, String algorithm, String secretId, this.initializationVector,
      [int? expiration])
      : super(id, algorithm, secretId, expiration);

  @override
  Map<String, dynamic> toJson() {
    var map = super.toJson();
    map.addAll({
      'initializationVector': initializationVector,
    });
    return map;
  }
}

/// User Authentication Parameters with hash
class UserAuthWithHashParams extends UserAuthParams {
  /// Digest used for representing the OUID
  String digest;

  /// Salt used for computing the OUID (optional)
  String? salt;

  UserAuthWithHashParams(String id, String algorithm, String secretId, this.digest, this.salt, [int? expiration])
      : super(id, algorithm, secretId, expiration);

  @override
  Map<String, dynamic> toJson() {
    var map = super.toJson();
    map.addAll({
      'digest': digest,
      'salt': salt,
    });
    return map;
  }
}

/// User Authentication Parameters without encryption or hash
class UserAuthWithoutParams extends UserAuth {
  UserAuthWithoutParams(String id) : super(id);
}
