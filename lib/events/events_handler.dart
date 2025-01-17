import 'package:didomi_sdk/constants.dart';
import 'package:didomi_sdk/entities/current_user_status.dart';
import 'package:didomi_sdk/events/sync_ready_event.dart';
import 'package:flutter/services.dart';

import 'event_listener.dart';

/// Handler for events emitted by native SDK
class EventsHandler {
  static const EventChannel _eventChannel = EventChannel(eventsChannelName);
  // Reference to the channel so we can call methods on the native side.
  MethodChannel _channel;
  List<EventListener> listeners = [];

  List<Function()> onReadyCallbacks = [];

  List<Function()> onErrorCallbacks = [];

  Map<String, List<Function(VendorStatus)>> vendorStatusListeners = {};

  EventsHandler(this._channel) {
    _eventChannel.receiveBroadcastStream().listen(handleDidomiEvent, onError: handleDidomiErrorEvent);
  }

  handleDidomiEvent(dynamic event) {
    final String eventType = event["type"].toString();

    switch (eventType) {
      case "onReady":
        for (var listener in listeners) {
          listener.onReady();
        }
        break;

      case "onReadyCallback":
        List<Function()> called = [];
        for (var listenerFunction in onReadyCallbacks) {
          listenerFunction();
          called.add(listenerFunction);
        }
        // Make sure callbacks are called only once
        for (var function in called) {
          onReadyCallbacks.remove(function);
        }
        break;

      case "onError":
        final String message = event["message"].toString();
        for (var listener in listeners) {
          listener.onError(message);
        }
        break;

      case "onErrorCallback":
        List<Function()> called = [];
        for (var listenerFunction in onErrorCallbacks) {
          listenerFunction();
          called.add(listenerFunction);
        }
        // Make sure callbacks are called only once
        for (var function in called) {
          onErrorCallbacks.remove(function);
        }
        break;

      case "onShowNotice":
        for (var listener in listeners) {
          listener.onShowNotice();
        }
        break;

      case "onHideNotice":
        for (var listener in listeners) {
          listener.onHideNotice();
        }
        break;

      case "onShowPreferences":
        for (var listener in listeners) {
          listener.onShowPreferences();
        }
        break;

      case "onHidePreferences":
        for (var listener in listeners) {
          listener.onHidePreferences();
        }
        break;

      case "onNoticeClickAgree":
        for (var listener in listeners) {
          listener.onNoticeClickAgree();
        }
        break;

      case "onNoticeClickDisagree":
        for (var listener in listeners) {
          listener.onNoticeClickDisagree();
        }
        break;

      case "onNoticeClickViewVendors":
        for (var listener in listeners) {
          listener.onNoticeClickViewVendors();
        }
        break;

      case "onNoticeClickMoreInfo":
        for (var listener in listeners) {
          listener.onNoticeClickMoreInfo();
        }
        break;

      case "onNoticeClickPrivacyPolicy":
        for (var listener in listeners) {
          listener.onNoticeClickPrivacyPolicy();
        }
        break;

      case "onPreferencesClickAgreeToAll":
        for (var listener in listeners) {
          listener.onPreferencesClickAgreeToAll();
        }
        break;

      case "onPreferencesClickDisagreeToAll":
        for (var listener in listeners) {
          listener.onPreferencesClickDisagreeToAll();
        }
        break;

      case "onPreferencesClickPurposeAgree":
        final String purposeId = event["purposeId"].toString();
        for (var listener in listeners) {
          listener.onPreferencesClickPurposeAgree(purposeId);
        }
        break;

      case "onPreferencesClickPurposeDisagree":
        final String purposeId = event["purposeId"].toString();
        for (var listener in listeners) {
          listener.onPreferencesClickPurposeDisagree(purposeId);
        }
        break;

      case "onPreferencesClickCategoryAgree":
        final String categoryId = event["categoryId"].toString();
        for (var listener in listeners) {
          listener.onPreferencesClickCategoryAgree(categoryId);
        }
        break;

      case "onPreferencesClickCategoryDisagree":
        final String categoryId = event["categoryId"].toString();
        for (var listener in listeners) {
          listener.onPreferencesClickCategoryDisagree(categoryId);
        }
        break;

      case "onPreferencesClickViewVendors":
        for (var listener in listeners) {
          listener.onPreferencesClickViewVendors();
        }
        break;

      case "onPreferencesClickSaveChoices":
        for (var listener in listeners) {
          listener.onPreferencesClickSaveChoices();
        }
        break;

      case "onPreferencesClickVendorAgree":
        final String vendorId = event["vendorId"].toString();
        for (var listener in listeners) {
          listener.onPreferencesClickVendorAgree(vendorId);
        }
        break;

      case "onPreferencesClickVendorDisagree":
        final String vendorId = event["vendorId"].toString();
        for (var listener in listeners) {
          listener.onPreferencesClickVendorDisagree(vendorId);
        }
        break;

      case "onPreferencesClickVendorSaveChoices":
        for (var listener in listeners) {
          listener.onPreferencesClickVendorSaveChoices();
        }
        break;

      case "onPreferencesClickViewPurposes":
        for (var listener in listeners) {
          listener.onPreferencesClickViewPurposes();
        }
        break;

      case "onPreferencesClickAgreeToAllPurposes":
        for (var listener in listeners) {
          listener.onPreferencesClickAgreeToAllPurposes();
        }
        break;

      case "onPreferencesClickDisagreeToAllPurposes":
        for (var listener in listeners) {
          listener.onPreferencesClickDisagreeToAllPurposes();
        }
        break;

      case "onPreferencesClickResetAllPurposes":
        for (var listener in listeners) {
          listener.onPreferencesClickResetAllPurposes();
        }
        break;

      case "onPreferencesClickAgreeToAllVendors":
        for (var listener in listeners) {
          listener.onPreferencesClickAgreeToAllVendors();
        }
        break;

      case "onPreferencesClickDisagreeToAllVendors":
        for (var listener in listeners) {
          listener.onPreferencesClickDisagreeToAllVendors();
        }
        break;

      case "onConsentChanged":
        for (var listener in listeners) {
          listener.onConsentChanged();
        }
        break;

      case "onSyncReady":
        for (var listener in listeners) {
          final SyncReadyEvent newEvent = SyncReadyEvent(
            event["organizationUserId"],
            event["statusApplied"],
            () async {
              // This method allows us to execute the syncAcknowledged callback from the flutter side.
              // We need to send the Sync Ready Event Index to the native side so native knows which event needs to trigger the syncAcknowledged callback.
              return await _channel.invokeMethod("executeSyncAcknowledgedCallback", {"syncReadyEventIndex": event["syncReadyEventIndex"]});
            }
          );
          listener.onSyncReady(newEvent);
        }
        break;

      case "onSyncDone":
        final String organizationUserId = event["organizationUserId"].toString();
        for (var listener in listeners) {
          // ignore: deprecated_member_use_from_same_package
          listener.onSyncDone(organizationUserId);
        }
        break;

      case "onSyncError":
        final String error = event["error"].toString();
        for (var listener in listeners) {
          listener.onSyncError(error);
        }
        break;

      case "onLanguageUpdated":
        final String languageCode = event["languageCode"].toString();
        for (var listener in listeners) {
          listener.onLanguageUpdated(languageCode);
        }
        break;

      case "onLanguageUpdateFailed":
        final String reason = event["reason"].toString();
        for (var listener in listeners) {
          listener.onLanguageUpdateFailed(reason);
        }
        break;

      case "onVendorStatusChanged":
        final VendorStatus vendorStatus = VendorStatus.fromJson(event["vendorStatus"]);
        final List<Function(VendorStatus)> callbacks = vendorStatusListeners[vendorStatus.id] ?? [];
        for (var callback in callbacks) {
          callback(vendorStatus);
        }
        break;

      default:
        print("Received invalid event: $eventType");
        break;
    }
  }

  handleDidomiErrorEvent(dynamic error) => print('Received error: ${error.message}');

  /// Add an event listener
  addEventListener(EventListener listener) {
    if (!listeners.contains(listener)) {
      listeners.add(listener);
    }
  }

  /// Remove an event listener
  removeEventListener(EventListener listener) {
    listeners.remove(listener);
  }

  /// Add a vendor status listener
  addVendorStatusListener(String vendorId, Function(VendorStatus) listener) {
    List<Function(VendorStatus)>? listeners = vendorStatusListeners[vendorId];
    if (listeners == null) {
      vendorStatusListeners[vendorId] = [listener];
    } else {
      listeners.add(listener);
    }
  }

  /// Remove listeners for the vendor status
  removeVendorStatusListener(String vendorId) {
    vendorStatusListeners.remove(vendorId);
  }
}
