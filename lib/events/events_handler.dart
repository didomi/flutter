import 'dart:convert';

import 'package:didomi_sdk/events/event_listener.dart';
import 'package:flutter/services.dart';
import 'package:didomi_sdk/constants.dart';

/// Handler for events emitted by native SDK
class EventsHandler {
  static const EventChannel _eventChannel = EventChannel(eventsChannelName);
  List<EventListener> listeners = [];
  List<Function()> onReadyCallbacks = [];
  List<Function()> onErrorCallbacks = [];

  EventsHandler() {
    _eventChannel.receiveBroadcastStream().listen(handleDidomiEvent, onError: handleDidomiErrorEvent);
  }

  handleDidomiEvent(dynamic event) {
    try {
      handleDecodedEvent(json.decode(event));
    } on FormatException catch(e) {
      print("Error while decoding event : $e");
    }
  }

  handleDecodedEvent(Map jsonEvent) {
    final String eventType = jsonEvent["type"].toString();
    print("Received event : $eventType");

    switch(eventType) {
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
}
