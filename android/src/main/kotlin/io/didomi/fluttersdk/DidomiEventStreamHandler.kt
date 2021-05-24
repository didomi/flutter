package io.didomi.fluttersdk

import io.didomi.sdk.events.*
import io.didomi.sdk.functionalinterfaces.DidomiEventListener
import io.flutter.plugin.common.EventChannel
import org.json.JSONObject

/**
 * Handler for SDK events
 */
class DidomiEventStreamHandler: EventChannel.StreamHandler, DidomiEventListener {

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

    override fun noticeClickAgree(event: NoticeClickAgreeEvent) {
        sendEvent("onNoticeClickAgree")
    }

    override fun noticeClickDisagree(event: NoticeClickDisagreeEvent) {
        sendEvent("onNoticeClickDisagree")
    }

    override fun noticeClickViewVendors(event: NoticeClickViewVendorsEvent) {
        sendEvent("onNoticeClickViewVendors")
    }

    override fun noticeClickMoreInfo(event: NoticeClickMoreInfoEvent) {
        sendEvent("onNoticeClickMoreInfo")
    }

    override fun noticeClickPrivacyPolicy(event: NoticeClickPrivacyPolicyEvent) {
        sendEvent("onNoticeClickPrivacyPolicy")
    }

    override fun preferencesClickAgreeToAll(event: PreferencesClickAgreeToAllEvent) {
        sendEvent("onPreferencesClickAgreeToAll")
    }

    override fun preferencesClickDisagreeToAll(event: PreferencesClickDisagreeToAllEvent) {
        sendEvent("onPreferencesClickDisagreeToAll")
    }

    override fun preferencesClickPurposeAgree(event: PreferencesClickPurposeAgreeEvent) {
        sendEvent("onPreferencesClickPurposeAgree", mapOf("purposeId" to event.purposeId))
    }

    override fun preferencesClickPurposeDisagree(event: PreferencesClickPurposeDisagreeEvent) {
        sendEvent("onPreferencesClickPurposeDisagree", mapOf("purposeId" to event.purposeId))
    }

    override fun preferencesClickCategoryAgree(event: PreferencesClickCategoryAgreeEvent) {
        sendEvent("onPreferencesClickCategoryAgree", mapOf("categoryId" to event.categoryId))
    }

    override fun preferencesClickCategoryDisagree(event: PreferencesClickCategoryDisagreeEvent) {
        sendEvent("onPreferencesClickCategoryDisagree", mapOf("categoryId" to event.categoryId))
    }

    override fun preferencesClickViewVendors(event: PreferencesClickViewVendorsEvent) {
        sendEvent("onPreferencesClickViewVendors")
    }

    override fun preferencesClickSaveChoices(event: PreferencesClickSaveChoicesEvent) {
        sendEvent("onPreferencesClickSaveChoices")
    }

    override fun preferencesClickVendorAgree(event: PreferencesClickVendorAgreeEvent) {
        sendEvent("onPreferencesClickVendorAgree", mapOf("vendorId" to event.vendorId))
    }

    override fun preferencesClickVendorDisagree(event: PreferencesClickVendorDisagreeEvent) {
        sendEvent("onPreferencesClickVendorDisagree", mapOf("vendorId" to event.vendorId))
    }

    override fun preferencesClickVendorSaveChoices(event: PreferencesClickVendorSaveChoicesEvent) {
        sendEvent("onPreferencesClickVendorSaveChoices")
    }

    override fun preferencesClickViewPurposes(event: PreferencesClickViewPurposesEvent) {
        sendEvent("onPreferencesClickViewPurposes")
    }

    override fun hideNotice(event: HideNoticeEvent) {
        sendEvent("onHideNotice")
    }

    override fun consentChanged(event: ConsentChangedEvent) {
        sendEvent("onConsentChanged")
    }

    override fun ready(event: ReadyEvent) {
        sendEvent("onReady")
    }

    override fun error(event: ErrorEvent) {
        sendEvent("onError", mapOf("message" to event.errorMessage))
    }

    override fun preferencesClickAgreeToAllPurposes(event: PreferencesClickAgreeToAllPurposesEvent) {
        sendEvent("onPreferencesClickAgreeToAllPurposes")
    }

    override fun preferencesClickDisagreeToAllPurposes(event: PreferencesClickDisagreeToAllPurposesEvent) {
        sendEvent("onPreferencesClickDisagreeToAllPurposes")
    }

    override fun preferencesClickResetAllPurposes(event: PreferencesClickResetAllPurposesEvent) {
        sendEvent("onPreferencesClickResetAllPurposes")
    }

    override fun preferencesClickAgreeToAllVendors(event: PreferencesClickAgreeToAllVendorsEvent) {
        sendEvent("onPreferencesClickAgreeToAllVendors")
    }

    override fun preferencesClickDisagreeToAllVendors(event: PreferencesClickDisagreeToAllVendorsEvent) {
        sendEvent("onPreferencesClickDisagreeToAllVendors")
    }

    override fun syncDone(event: SyncDoneEvent) {
        sendEvent("onSyncDone", mapOf("organizationUserId" to event.organizationUserId))
    }

    fun onReadyCallback() {
        sendEvent("onReadyCallback")
    }

    fun onErrorCallback() {
        sendEvent("onErrorCallback")
    }

    private fun sendEvent(eventType: String, arguments: Map<String, String?>? = null) {
        val jsonEvent = JSONObject()
        jsonEvent.put("type", eventType)
        arguments?.entries?.forEach {
            jsonEvent.put(it.key, it.value)
        }
        val toString = jsonEvent.toString()
        this.eventSink?.success(toString)
    }
}
