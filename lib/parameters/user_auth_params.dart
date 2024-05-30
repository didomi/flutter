abstract class UserAuthParams {
  /// Organization ID to associate with the user
  String id;

  /// Algorithm used for computing the user ID
  String algorithm;

  /// ID of the secret used for computing the user ID
  String secretId;

  /// Expiration date as timestamp (to prevent replay attacks)
  int? expiration;

  UserAuthParams(this.id, this.algorithm, this.secretId, this.expiration);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'algorithm': algorithm,
      'secretId': secretId,
      'expiration': expiration,
    };
  }
}

class UserAuthWithEncryptionParams extends UserAuthParams {
  /// Initialization Vector used for computing the user ID
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

class UserAuthWithHashParams extends UserAuthParams {
  /// Digest used for representing the user ID
  String digest;

  /// Salt used for computing the user ID (optional)
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
