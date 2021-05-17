package io.didomi.fluttersdk

import io.didomi.sdk.events.*
import io.flutter.plugin.common.EventChannel
import org.json.JSONObject

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

    override fun ready(event: ReadyEvent) {
        sendEvent("onReady");
    }

    override fun error(event: ErrorEvent) {
        sendEvent("onError", message = event.errorMessage)
    }

    fun onReadyCallback() {
        sendEvent("onReadyCallback")
    }

    private fun sendEvent(eventType: String, message: String? = null) {
        val jsonEvent = JSONObject()
        jsonEvent.put("type", eventType)
        message?.also { jsonEvent.put("message", it) }
        val toString = jsonEvent.toString()
        this.eventSink?.success(toString)
    }
}
