package io.didomi.fluttersdk

import io.didomi.sdk.events.*
import io.didomi.sdk.functionalinterfaces.DidomiEventListener
import io.flutter.plugin.common.EventChannel
import org.json.JSONObject
import io.didomi.sdk.models.CurrentUserStatus.VendorStatus

/**
 * Handler for SDK events
 */
class DidomiEventStreamHandler : EventChannel.StreamHandler, DidomiEventListener {

    private var eventSink: EventChannel.EventSink? = null
    // We keep references to all the Sync Ready events being registered so we can call their respective syncAcknowledged callback from the Flutter side through a method channel.
    private var syncReadyEventReferences: MutableMap<Int, SyncReadyEvent> = mutableMapOf()
    // Index used to keep track of the Sync Ready events being registered.
    private var syncReadyEventIndex: Int = 0

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        this.eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        this.eventSink = null
    }

    /*
     * SDK lifecycle events
     */

    override fun ready(event: ReadyEvent) {
        sendEvent("onReady")
    }

    fun onReadyCallback() {
        sendEvent("onReadyCallback")
    }

    override fun error(event: ErrorEvent) {
        sendEvent("onError", mapOf("message" to event.errorMessage))
    }

    fun onErrorCallback() {
        sendEvent("onErrorCallback")
    }

    /*
     * Notice events
     */

    override fun showNotice(event: ShowNoticeEvent) {
        sendEvent("onShowNotice")
    }

    override fun hideNotice(event: HideNoticeEvent) {
        sendEvent("onHideNotice")
    }

    override fun showPreferences(event: ShowPreferencesEvent) {
        sendEvent("onShowPreferences")
    }

    override fun hidePreferences(event: HidePreferencesEvent) {
        sendEvent("onHidePreferences")
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

    override fun noticeClickViewSPIPurposes(event: NoticeClickViewSPIPurposesEvent) {
        sendEvent("noticeClickViewSPIPurposes")
    }

    override fun noticeClickMoreInfo(event: NoticeClickMoreInfoEvent) {
        sendEvent("onNoticeClickMoreInfo")
    }

    override fun noticeClickPrivacyPolicy(event: NoticeClickPrivacyPolicyEvent) {
        sendEvent("onNoticeClickPrivacyPolicy")
    }

    /*
     * Preferences screen events
     */

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

    override fun preferencesClickViewSPIPurposes(event: PreferencesClickViewSPIPurposesEvent) {
        sendEvent("preferencesClickViewSPIPurposes")
    }

    override fun preferencesClickSaveChoices(event: PreferencesClickSaveChoicesEvent) {
        sendEvent("onPreferencesClickSaveChoices")
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

    /*
     * Vendors screen events
     */

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

    override fun preferencesClickAgreeToAllVendors(event: PreferencesClickAgreeToAllVendorsEvent) {
        sendEvent("onPreferencesClickAgreeToAllVendors")
    }

    override fun preferencesClickDisagreeToAllVendors(event: PreferencesClickDisagreeToAllVendorsEvent) {
        sendEvent("onPreferencesClickDisagreeToAllVendors")
    }

    /*
     * SPI screen events
     */

    override fun preferencesClickSPIPurposeAgree(event: PreferencesClickSPIPurposeAgreeEvent) {
        sendEvent("preferencesClickSPIPurposeAgree", mapOf("purposeId" to event.purposeId))
    }

    override fun preferencesClickSPIPurposeDisagree(event: PreferencesClickSPIPurposeDisagreeEvent) {
        sendEvent("onPreferencesClickSPIPurposeDisagree", mapOf("purposeId" to event.purposeId))
    }

    override fun preferencesClickSPICategoryAgree(event: PreferencesClickSPICategoryAgreeEvent) {
        sendEvent("onPreferencesClickSPICategoryAgree", mapOf("categoryId" to event.categoryId))
    }

    override fun preferencesClickSPICategoryDisagree(event: PreferencesClickSPICategoryDisagreeEvent) {
        sendEvent("onPreferencesClickSPICategoryDisagree", mapOf("categoryId" to event.categoryId))
    }

    override fun preferencesClickSPIPurposeSaveChoices(event: PreferencesClickSPIPurposeSaveChoicesEvent) {
        sendEvent("preferencesClickSPIPurposeSaveChoices")
    }

    /*
     * Consent events
     */

    override fun consentChanged(event: ConsentChangedEvent) {
        sendEvent("onConsentChanged")
    }

    override fun syncReady(event: SyncReadyEvent) {
        syncReadyEventIndex++
        syncReadyEventReferences.put(syncReadyEventIndex, event)
        sendEvent("onSyncReady", mapOf("statusApplied" to event.statusApplied, "syncReadyEventIndex" to syncReadyEventIndex))
    }

    override fun syncDone(event: SyncDoneEvent) {
        sendEvent("onSyncDone", mapOf("organizationUserId" to event.organizationUserId))
    }

    override fun syncError(event: SyncErrorEvent) {
        sendEvent("onSyncError", mapOf("error" to event.error))
    }

    /*
     * Language change events
     */

    override fun languageUpdated(event: LanguageUpdatedEvent) {
        sendEvent("onLanguageUpdated", mapOf("languageCode" to event.languageCode))
    }

    override fun languageUpdateFailed(event: LanguageUpdateFailedEvent) {
        sendEvent("onLanguageUpdateFailed", mapOf("reason" to event.reason))
    }

    /*
     * Vendor status change event
     */

    fun onVendorStatusChanged(vendorStatus: VendorStatus) {
        val vendorStatusMap = EntitiesHelper.toMap(vendorStatus)
        sendEvent("onVendorStatusChanged", mapOf("vendorStatus" to vendorStatusMap))
    }

    /*
     * Common method
     */

    private fun sendEvent(eventType: String, arguments: Map<String, *>? = null) {
        val event = mutableMapOf<String, Any?>("type" to eventType)
        arguments?.also { event.putAll(it) }
        this.eventSink?.success(event)
    }

    // Request to execute a specific syncAcknowledged callback. It returns **true** if the API Event was sent, **false** otherwise.
    fun executeSyncAcknowledgedCallback(index: Int): Boolean {
        val eventWasSent = syncReadyEventReferences[index]?.syncAcknowledged?.invoke()
        clearSyncReadyEventReference(index)
        return eventWasSent ?: false
    }

    // Remove a specific reference to a Sync Ready Event
    fun clearSyncReadyEventReference(index: Int) {
        syncReadyEventReferences.remove(index)
    }

    // Clear all the references to the Sync Ready Events
    fun clearSyncReadyEventReferences() {
        syncReadyEventReferences.clear()
    }
}
