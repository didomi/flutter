
/// Listener to events sent by the Didomi SDK
class EventListener {
  /// SDK is ready
  dynamic Function() onReady = () {};
  /// SDK encountered an error
  dynamic Function(String message) onError = (message) {};
  /// Notice was displayed
  dynamic Function() onShowNotice = () {};
  /// Notice was hidden
  dynamic Function() onHideNotice = () {};
}