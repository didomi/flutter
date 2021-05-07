import 'dart:convert';

import 'package:didomi_sdk/events/event_listener.dart';
import 'package:flutter/services.dart';

/// Handler for events emitted by native SDK
class EventsHandler {
  static const EventChannel _eventChannel = EventChannel("didomi_sdk/events");
  List<EventListener> listeners = [];

  EventsHandler() {
    _eventChannel.receiveBroadcastStream().listen(handleDidomiEvent, onError: handleDidomiErrorEvent);
  }

  handleDidomiEvent(dynamic event) {
    if (listeners.isEmpty) {
      return;
    }
    Map jsonEvent = json.decode(event);

    final String eventType = jsonEvent["type"].toString();

    switch(eventType) {
      case "onReady":
        for (var listener in listeners) {
          listener.onReady();
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