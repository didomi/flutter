import 'dart:convert';

import 'package:didomi_sdk/constants.dart';
import 'package:flutter/services.dart';

import 'event_listener.dart';

/// Handler for events emitted by native SDK
class EventsHandler {
  static const EventChannel _eventChannel = EventChannel(eventsChannelName);
  List<EventListener> listeners = [];

  List<Function()> onReadyCallbacks = [];

  List<Function()> onErrorCallbacks = [];

  EventsHandler() {
    _eventChannel
        .receiveBroadcastStream()
        .listen(handleDidomiEvent, onError: handleDidomiErrorEvent);
  }

  handleDidomiEvent(dynamic event) {
    try {
      handleDecodedEvent(json.decode(event));
    } on FormatException catch (e) {
      print("Error while decoding event $event: $e");
    }
  }

  handleDecodedEvent(Map jsonEvent) {
    final String eventType = jsonEvent["type"].toString();

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
        final String message = jsonEvent["message"].toString();
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
          listener.onPreferencesClickAgreeToAll();
        }
        break;

      case "onPreferencesClickPurposeAgree":
        final String purposeId = jsonEvent["purposeId"].toString();
        for (var listener in listeners) {
          listener.onPreferencesClickPurposeAgree(purposeId);
        }
        break;

      case "onPreferencesClickPurposeDisagree":
        final String purposeId = jsonEvent["purposeId"].toString();
        for (var listener in listeners) {
          listener.onPreferencesClickPurposeDisagree(purposeId);
        }
        break;

      case "onPreferencesClickCategoryAgree":
        final String categoryId = jsonEvent["categoryId"].toString();
        for (var listener in listeners) {
          listener.onPreferencesClickCategoryAgree(categoryId);
        }
        break;

      case "onPreferencesClickCategoryDisagree":
        final String categoryId = jsonEvent["categoryId"].toString();
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
        final String vendorId = jsonEvent["vendorId"].toString();
        for (var listener in listeners) {
          listener.onPreferencesClickVendorAgree(vendorId);
        }
        break;

      case "onPreferencesClickVendorDisagree":
        final String vendorId = jsonEvent["vendorId"].toString();
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

      case "onConsentChanged":
        for (var listener in listeners) {
          listener.onConsentChanged();
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

      case "onSyncDone":
        final String organizationUserId =
            jsonEvent["organizationUserId"].toString();
        for (var listener in listeners) {
          listener.onSyncDone(organizationUserId);
        }
        break;

      case "onSyncError":
        final String error = jsonEvent["error"].toString();
        for (var listener in listeners) {
          listener.onSyncError(error);
        }
        break;

      case "onLanguageUpdated":
        final String languageCode = jsonEvent["languageCode"].toString();
        for (var listener in listeners) {
          listener.onLanguageUpdated(languageCode);
        }
        break;

      case "onLanguageUpdateFailed":
        final String reason = jsonEvent["reason"].toString();
        for (var listener in listeners) {
          listener.onLanguageUpdateFailed(reason);
        }
        break;

      default:
        print("Received invalid event: $eventType");
        break;
    }
  }

  handleDidomiErrorEvent(dynamic error) =>
      print('Received error: ${error.message}');

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
}
