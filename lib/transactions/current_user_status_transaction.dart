typedef NativeCallback = Future<bool> Function(
    List<String> enabledPurposes, List<String> disabledPurposes, List<String> enabledVendors, List<String> disabledVendors);

/// Class used to contain all the operations related to transactions.
/// All the changes regarding the status of purposes and vendors will
/// only be communicated to the native SDKs once the `commit` method is called.
class CurrentUserStatusTransaction {
  final Map<String, bool> purposesStatus = {};
  final Map<String, bool> vendorsStatus = {};

  /// Callback used to communicate the updates made through this transaction to
  /// the native SDKs.
  final NativeCallback nativeCallback;

  CurrentUserStatusTransaction(this.nativeCallback);

  /// Enable multiple purposes.
  CurrentUserStatusTransaction enablePurposes(List<String> ids) {
    ids.forEach(enablePurpose);
    return this;
  }

  /// Enable a single purpose.
  CurrentUserStatusTransaction enablePurpose(String id) {
    purposesStatus[id] = true;
    return this;
  }

  /// Disable multiple purposes.
  CurrentUserStatusTransaction disablePurposes(List<String> ids) {
    ids.forEach(disablePurpose);
    return this;
  }

  /// Disable a single purpose.
  CurrentUserStatusTransaction disablePurpose(String id) {
    purposesStatus[id] = false;
    return this;
  }

  /// Enable multiple vendors.
  CurrentUserStatusTransaction enableVendors(List<String> ids) {
    ids.forEach(enableVendor);
    return this;
  }

  /// Enable a single vendor.
  CurrentUserStatusTransaction enableVendor(String id) {
    vendorsStatus[id] = true;
    return this;
  }

  /// Disable multiple vendors.
  CurrentUserStatusTransaction disableVendors(List<String> ids) {
    ids.forEach(disableVendor);
    return this;
  }

  /// Disable a single vendor.
  CurrentUserStatusTransaction disableVendor(String id) {
    vendorsStatus[id] = false;
    return this;
  }

  /// Communicate changes made through this class to the native SDK.
  Future<bool> commit() async {
    final enabledPurposes = purposesStatus.entries.where((e) => e.value).map((e) => e.key).toList();
    final disabledPurposes = purposesStatus.entries.where((e) => !e.value).map((e) => e.key).toList();
    final enabledVendors = vendorsStatus.entries.where((e) => e.value).map((e) => e.key).toList();
    final disabledVendors = vendorsStatus.entries.where((e) => !e.value).map((e) => e.key).toList();

    return await nativeCallback(enabledPurposes, disabledPurposes, enabledVendors, disabledVendors);
  }
}
