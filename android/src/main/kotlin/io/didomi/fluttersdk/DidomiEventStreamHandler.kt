package io.didomi.fluttersdk

import io.didomi.sdk.events.EventListener
import io.didomi.sdk.events.HideNoticeEvent
import io.didomi.sdk.events.ReadyEvent
import io.didomi.sdk.events.ShowNoticeEvent
import io.flutter.plugin.common.EventChannel

/**
 * Handler for SDK events
 */
class DidomiEventStreamHandler: EventChannel.StreamHandler, EventListener() {
    private var eventSink: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        this.eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        this.eventSink = null
    }

    override fun showNotice(event: ShowNoticeEvent) {
        sendEvent("onShowNotice")
    }

    override fun hideNotice(event: HideNoticeEvent) {
        sendEvent("onHideNotice")
    }

    override fun ready(event: ReadyEvent?) {
        sendEvent("onReady");
    }

    private fun sendEvent(eventType: String) {
        this.eventSink?.success("{\"type\":\"$eventType\"}")
    }
}