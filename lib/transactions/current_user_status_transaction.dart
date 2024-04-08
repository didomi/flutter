/// Callback to be called when the changes made through a transaction need to be sent to the native SDK.
typedef CurrentUserStatusTransactionCallback = Future<bool> Function(
    List<String> enabledPurposes, List<String> disabledPurposes, List<String> enabledVendors, List<String> disabledVendors);

/// Class used to contain all the operations related to transactions.
/// All the changes regarding the status of purposes and vendors will
/// only be communicated to the native SDKs once the `commit` method is called.
class CurrentUserStatusTransaction {
  final Map<String, bool> _purposesStatus = {};
  final Map<String, bool> _vendorsStatus = {};

  /// Callback used to communicate the updates made through this transaction to
  /// the native SDKs.
  final CurrentUserStatusTransactionCallback _nativeCallback;

  CurrentUserStatusTransaction(this._nativeCallback);

  /// Enable multiple purposes.
  CurrentUserStatusTransaction enablePurposes(List<String> ids) {
    ids.forEach(enablePurpose);
    return this;
  }

  /// Enable a single purpose.
  CurrentUserStatusTransaction enablePurpose(String id) {
    _purposesStatus[id] = true;
    return this;
  }

  /// Disable multiple purposes.
  CurrentUserStatusTransaction disablePurposes(List<String> ids) {
    ids.forEach(disablePurpose);
    return this;
  }

  /// Disable a single purpose.
  CurrentUserStatusTransaction disablePurpose(String id) {
    _purposesStatus[id] = false;
    return this;
  }

  /// Enable multiple vendors.
  CurrentUserStatusTransaction enableVendors(List<String> ids) {
    ids.forEach(enableVendor);
    return this;
  }

  /// Enable a single vendor.
  CurrentUserStatusTransaction enableVendor(String id) {
    _vendorsStatus[id] = true;
    return this;
  }

  /// Disable multiple vendors.
  CurrentUserStatusTransaction disableVendors(List<String> ids) {
    ids.forEach(disableVendor);
    return this;
  }

  /// Disable a single vendor.
  CurrentUserStatusTransaction disableVendor(String id) {
    _vendorsStatus[id] = false;
    return this;
  }

  /// Communicate changes made through this class to the native SDK.
  Future<bool> commit() async {
    final enabledPurposes = _purposesStatus.entries.where((e) => e.value).map((e) => e.key).toList();
    final disabledPurposes = _purposesStatus.entries.where((e) => !e.value).map((e) => e.key).toList();
    final enabledVendors = _vendorsStatus.entries.where((e) => e.value).map((e) => e.key).toList();
    final disabledVendors = _vendorsStatus.entries.where((e) => !e.value).map((e) => e.key).toList();

    return await _nativeCallback(enabledPurposes, disabledPurposes, enabledVendors, disabledVendors);
  }
}
