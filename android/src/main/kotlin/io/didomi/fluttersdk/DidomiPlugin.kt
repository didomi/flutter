package io.didomi.fluttersdk

import android.app.Activity
import androidx.annotation.NonNull
import androidx.fragment.app.FragmentActivity
import com.google.gson.JsonParseException
import io.didomi.sdk.Didomi
import io.didomi.sdk.DidomiInitializeParameters
import io.didomi.sdk.exceptions.DidomiNotReadyException
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/**
 * Didomi SDK Plugin
 */
class DidomiPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

    private lateinit var channel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private val eventStreamHandler = DidomiEventStreamHandler()

    /// The Activity used to interact with the Didomi SDK.
    ///
    /// This is always the current displayed Activity, as activities can not be passed through Flutter channels
    private var currentActivity: Activity? = null

    init {
        // Set User Agent for Flutter
        Didomi.getInstance().setUserAgent(BuildConfig.USER_AGENT_NAME, BuildConfig.PLUGIN_VERSION)
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "didomi_sdk")
        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "didomi_sdk/events")
        eventChannel.setStreamHandler(eventStreamHandler)
        channel.setMethodCallHandler(this)

        Didomi.getInstance().addEventListener(eventStreamHandler)
    }

    override fun onAttachedToActivity(activityPluginBinding: ActivityPluginBinding) {
        // Update the current activity
        currentActivity = activityPluginBinding.activity
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
    }

    override fun onDetachedFromActivity() {
        // Release the current activity
        currentActivity = null
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        val didomi = Didomi.getInstance()
        try {
            when (call.method) {

                "initialize" -> initialize(call, result)

                "isReady" -> result.success(didomi.isReady)

                "onReady" -> didomi.onReady {
                    eventStreamHandler.onReadyCallback()
                }

                "onError" -> didomi.onError {
                    eventStreamHandler.onErrorCallback()
                }

                "shouldConsentBeCollected" -> result.success(didomi.shouldConsentBeCollected())

                "isConsentRequired" -> result.success(didomi.isConsentRequired)

                "isUserConsentStatusPartial" -> result.success(didomi.isUserConsentStatusPartial)

                "isUserLegitimateInterestStatusPartial" -> result.success(didomi.isUserLegitimateInterestStatusPartial)

                "reset" -> reset(result)

                "setupUI" -> {
                    getFragmentActivity(result)?.also {
                        didomi.setupUI(it)
                        result.success(null)
                    }
                }

                "showNotice" -> showNotice(result)

                "hideNotice" -> {
                    didomi.hideNotice()
                    result.success(null)
                }

                "isNoticeVisible" -> {
                    result.success(didomi.isNoticeVisible)
                }

                "showPreferences" -> showPreferences(call, result)

                "hidePreferences" -> {
                    didomi.hidePreferences()
                    result.success(null)
                }

                "isPreferencesVisible" -> {
                    result.success(didomi.isPreferencesVisible)
                }

                "getJavaScriptForWebView" -> getJavaScriptForWebView(result)

                "getQueryStringForWebView" -> result.success(didomi.queryStringForWebView)

                "updateSelectedLanguage" -> updateSelectedLanguage(call, result)

                "getText" -> getText(call, result)

                "getTranslatedText" -> getTranslatedText(call, result)

                "getUserStatus" -> getUserStatus(result)

                "getDisabledPurposeIds" -> getDisabledPurposeIds(result)

                "getDisabledVendorIds" -> getDisabledVendorIds(result)

                "getEnabledPurposeIds" -> getEnabledPurposeIds(result)

                "getEnabledVendorIds" -> getEnabledVendorIds(result)

                "getRequiredPurposeIds" -> getRequiredPurposeIds(result)

                "getRequiredVendorIds" -> getRequiredVendorIds(result)

                "getDisabledPurposes" -> getDisabledPurposes(result)

                "getDisabledVendors" -> getDisabledVendors(result)

                "getEnabledPurposes" -> getEnabledPurposes(result)

                "getEnabledVendors" -> getEnabledVendors(result)

                "getRequiredPurposes" -> getRequiredPurposes(result)

                "getRequiredVendors" -> getRequiredVendors(result)

                "getPurpose" -> getPurpose(call, result)

                "getVendor" -> getVendor(call, result)

                "setLogLevel" -> setLogLevel(call, result)

                "setUserAgreeToAll" -> setUserAgreeToAll(result)

                "setUserDisagreeToAll" -> setUserDisagreeToAll(result)

                "getUserConsentStatusForPurpose" -> getUserConsentStatusForPurpose(call, result)

                "getUserConsentStatusForVendor" -> getUserConsentStatusForVendor(call, result)

                "getUserConsentStatusForVendorAndRequiredPurposes" -> getUserConsentStatusForVendorAndRequiredPurposes(call, result)

                "getUserLegitimateInterestStatusForPurpose" -> getUserLegitimateInterestStatusForPurpose(call, result)

                "getUserLegitimateInterestStatusForVendor" -> getUserLegitimateInterestStatusForVendor(call, result)

                "getUserLegitimateInterestStatusForVendorAndRequiredPurposes" -> getUserLegitimateInterestStatusForVendorAndRequiredPurposes(call, result)

                "getUserStatusForVendor" -> getUserStatusForVendor(call, result)

                "setUserStatus" -> setUserStatus(call, result)

                "setUserStatusGlobally" -> setUserStatusGlobally(call, result)

                "setUser" -> setUser(call, result)

                "setUserWithAuthentication" -> setUserWithAuthentication(call, result)

                else -> result.notImplemented()
            }
        } catch (e: Exception) {
            result.error("didomi_exception", "An error occurred: ${e.message}", e)
        }
    }

    private fun initialize(call: MethodCall, result: Result) {
        currentActivity?.also {
            val apiKey = argumentOrError("apiKey", "initialize", call, result)
                    ?: return
            val disableDidomiRemoteConfig: Boolean = call.argument("disableDidomiRemoteConfig") ?: false
            Didomi.getInstance().initialize(
                it.application,
                DidomiInitializeParameters(
                    apiKey,
                    call.argument("localConfigurationPath"),
                    call.argument("remoteConfigurationURL"),
                    call.argument("providerId"),
                    disableDidomiRemoteConfig,
                    call.argument("languageCode"),
                    call.argument("noticeId")
                )
            )
            result.success(null)
        } ?: run {
            result.error("no_activity", "No activity available", null)
        }
    }

    private fun reset(result: Result) {
        try {
            Didomi.getInstance().reset()
            result.success(null)
        } catch (e: DidomiNotReadyException) {
            result.error("reset", e.message.orEmpty(), e)
        }
    }

    private fun showNotice(result: Result) {
        getFragmentActivity(result)?.also {
            Didomi.getInstance().showNotice(it)
            result.success(null)
        }
    }

    private fun showPreferences(call: MethodCall, result: Result) {
        getFragmentActivity(result)?.also {
            val view = (call.argument("view") as String?) ?: Didomi.VIEW_PURPOSES
            Didomi.getInstance().showPreferences(it, view)
            result.success(null)
        }
    }

    /**
     * Get the current activity as FragmentActivity, or raise an error
     */
    private fun getFragmentActivity(result: Result): FragmentActivity? = currentActivity?.let {
        if (it is FragmentActivity) {
            it
        } else {
            result.error("wrong_activity", "Requires FragmentActivity, was ${it::class.java}", null)
            null
        }
    } ?: run {
        result.error("no_activity", "No activity available", null)
        null
    }

    private fun updateSelectedLanguage(call: MethodCall, result: Result) {
        try {
            Didomi.getInstance().updateSelectedLanguage(call.argument("languageCode"))
            result.success(null)
        } catch (e: DidomiNotReadyException) {
            result.error("updateSelectedLanguage", e.message.orEmpty(), e)
        }
    }

    private fun getText(call: MethodCall, result: Result) {
        try {
            val textMap = Didomi.getInstance().getText(call.argument("key"))
            result.success(textMap)
        } catch (e: DidomiNotReadyException) {
            result.error("getText", e.message.orEmpty(), e)
        }
    }

    private fun getTranslatedText(call: MethodCall, result: Result) {
        try {
            val text = Didomi.getInstance().getTranslatedText(call.argument("key"))
            result.success(text)
        } catch (e: DidomiNotReadyException) {
            result.error("getTranslatedText", e.message.orEmpty(), e)
        }
    }

    /**
     * Get the JavaScript For WebView
     */
    private fun getJavaScriptForWebView(result: Result) {
        try {
            val text = Didomi.getInstance().javaScriptForWebView
            result.success(text)
        } catch (e: DidomiNotReadyException) {
            result.error("getJavaScriptForWebView", e.message.orEmpty(), e)
        }
    }

    /**
     * Get the IDs of the disabled purposes
     */
    private fun getUserStatus(result: Result) {
        try {
            val userStatus = Didomi.getInstance().userStatus
            val map = EntitiesHelper.toMap(userStatus)
            result.success(map)
        } catch (e: DidomiNotReadyException) {
            result.error("getUserStatus", e.message.orEmpty(), e)
        }
    }

    /**
     * Get the IDs of the disabled purposes
     */
    private fun getDisabledPurposeIds(result: Result) {
        try {
            val idSet = Didomi.getInstance().disabledPurposeIds
            result.success(idSet.toList())
        } catch (e: DidomiNotReadyException) {
            result.error("getDisabledPurposeIds", e.message.orEmpty(), e)
        }
    }

    /**
     * Get the IDs of the disabled vendors
     */
    private fun getDisabledVendorIds(result: Result) {
        try {
            val idSet = Didomi.getInstance().disabledVendorIds
            result.success(idSet.toList())
        } catch (e: DidomiNotReadyException) {
            result.error("getDisabledVendorIds", e.message.orEmpty(), e)
        }
    }

    /**
     * Get the IDs of the enabled purposes
     */
    private fun getEnabledPurposeIds(result: Result) {
        try {
            val idSet = Didomi.getInstance().enabledPurposeIds
            result.success(idSet.toList())
        } catch (e: DidomiNotReadyException) {
            result.error("getEnabledPurposeIds", e.message.orEmpty(), e)
        }
    }

    /**
     * Get the IDs of the enabled vendors
     */
    private fun getEnabledVendorIds(result: Result) {
        try {
            val idSet = Didomi.getInstance().enabledVendorIds
            result.success(idSet.toList())
        } catch (e: DidomiNotReadyException) {
            result.error("getEnabledVendorIds", e.message.orEmpty(), e)
        }
    }

    /**
     * Get the IDs of the required purposes
     */
    private fun getRequiredPurposeIds(result: Result) {
        try {
            val idSet = Didomi.getInstance().requiredPurposeIds
            result.success(idSet.toList())
        } catch (e: DidomiNotReadyException) {
            result.error("getRequiredPurposeIds", e.message.orEmpty(), e)
        }
    }

    /**
     * Get the IDs of the required vendors
     */
    private fun getRequiredVendorIds(result: Result) {
        try {
            val idSet = Didomi.getInstance().requiredVendorIds
            result.success(idSet.toList())
        } catch (e: DidomiNotReadyException) {
            result.error("getRequiredVendorIds", e.message.orEmpty(), e)
        }
    }

    /**
     * Get disabled purposes
     */
    private fun getDisabledPurposes(result: Result) {
        try {
            val purposes = Didomi.getInstance().disabledPurposes
            val list = EntitiesHelper.toList(purposes)
            result.success(list)
        } catch (e: Exception) {
            result.error("getRequiredPurposes", e.message.orEmpty(), e)
        }
    }

    /**
     * Get disabled vendors
     */
    private fun getDisabledVendors(result: Result) {
        try {
            val vendors = Didomi.getInstance().disabledVendors
            val list = EntitiesHelper.toList(vendors)
            result.success(list)
        } catch (e: Exception) {
            result.error("getDisabledVendors", e.message.orEmpty(), e)
        }
    }

    /**
     * Get enabled purposes
     */
    private fun getEnabledPurposes(result: Result) {
        try {
            val purposes = Didomi.getInstance().enabledPurposes
            val list = EntitiesHelper.toList(purposes)
            result.success(list)
        } catch (e: Exception) {
            result.error("getEnabledPurposes", e.message.orEmpty(), e)
        }
    }

    /**
     * Get enabled vendors
     */
    private fun getEnabledVendors(result: Result) {
        try {
            val vendors = Didomi.getInstance().enabledVendors
            val list = EntitiesHelper.toList(vendors)
            result.success(list)
        } catch (e: Exception) {
            result.error("getEnabledVendors", e.message.orEmpty(), e)
        }
    }

    /**
     * Get required purposes
     */
    private fun getRequiredPurposes(result: Result) {
        try {
            val purposes = Didomi.getInstance().requiredPurposes
            val list = EntitiesHelper.toList(purposes)
            result.success(list)
        } catch (e: Exception) {
            result.error("getRequiredPurposes", e.message.orEmpty(), e)
        }
    }

    /**
     * Get required vendors
     */
    private fun getRequiredVendors(result: Result) {
        try {
            val vendors = Didomi.getInstance().requiredVendors
            val list = EntitiesHelper.toList(vendors)
            result.success(list)
        } catch (e: Exception) {
            result.error("getRequiredVendors", e.message.orEmpty(), e)
        }
    }

    /**
     * Get a purpose by ID.
     */
    private fun getPurpose(call: MethodCall, result: Result) {
        try {
            val id: String? = call.argument("purposeId")
            val purpose = Didomi.getInstance().getPurpose(id)
            val map = EntitiesHelper.toMap(purpose)
            result.success(map)
        } catch (e: Exception) {
            result.error("getPurpose", e.message.orEmpty(), e)
        }
    }

    /**
     * Get a vendor by ID.
     */
    private fun getVendor(call: MethodCall, result: Result) {
        try {
            val id: String? = call.argument("vendorId")
            val vendor = Didomi.getInstance().getVendor(id)
            val map = EntitiesHelper.toMap(vendor)
            result.success(map)
        } catch (e: Exception) {
            result.error("getVendor", e.message.orEmpty(), e)
        }
    }

    /**
     * Set the minimum level of messages to log
     * <p>
     * Messages with a level below `minLevel` will not be logged.
     * Levels are standard levels from `android.util.Log` (https://developer.android.com/reference/android/util/Log#constants_1):
     * - android.util.Log.VERBOSE (2)
     * - android.util.Log.DEBUG (3)
     * - android.util.Log.INFO (4)
     * - android.util.Log.WARN (5)
     * - android.util.Log.ERROR (6)
     * <p>
     * We recommend setting `android.util.Log.WARN` in production
     */
    private fun setLogLevel(call: MethodCall, result: Result) {
        Didomi.getInstance().setLogLevel(call.argument("minLevel") as? Int ?: 2)
        result.success(null)
    }

    /**
     * Enable all purposes and vendors for the user.
     * @return true if user consent status was updated, false otherwise.
     */
    private fun setUserAgreeToAll(result: Result) {
        try {
            val consentHasBeenUpdated = Didomi.getInstance().setUserAgreeToAll()
            result.success(consentHasBeenUpdated)
        } catch (e: DidomiNotReadyException) {
            result.error("setUserAgreeToAll", e.message.orEmpty(), e)
        }
    }

    /**
     * Update user status to disagree : disable consent and legitimate interest purposes, disable consent vendors, but still enable legitimate interest vendors.
     * @return true if user status was updated, false otherwise.
     */
    private fun setUserDisagreeToAll(result: Result) {
        try {
            val consentHasBeenUpdated = Didomi.getInstance().setUserDisagreeToAll()
            result.success(consentHasBeenUpdated)
        } catch (e: DidomiNotReadyException) {
            result.error("setUserDisagreeToAll", e.message.orEmpty(), e)
        }
    }

    /**
     * Get the user consent status for a specific purpose
     * @param purposeId
     * @return The user consent status for the specified purpose
     */
    private fun getUserConsentStatusForPurpose(call: MethodCall, result: Result) {
        val purposeId = call.argument("purposeId") as? String
        if (purposeId.isNullOrBlank()) {
            result.error("getUserConsentStatusForPurpose", "purposeId is null or blank", null)
            return
        }
        try {
            val status = Didomi.getInstance().getUserConsentStatusForPurpose(purposeId)
            result.success(
                when (status) {
                    false -> 0
                    true -> 1
                    else -> 2
                }
            )
        } catch (e: DidomiNotReadyException) {
            result.error("getUserConsentStatusForPurpose", e.message.orEmpty(), e)
        }
    }

    /**
     * Get the user consent status for a specific vendor
     * @param vendorId
     * @return The user consent status for the specified vendor
     */
    private fun getUserConsentStatusForVendor(call: MethodCall, result: Result) {
        val vendorId = call.argument("vendorId") as? String
        if (vendorId.isNullOrBlank()) {
            result.error("getUserConsentStatusForVendor", "vendorId is null or blank", null)
            return
        }
        try {
            val status = Didomi.getInstance().getUserConsentStatusForVendor(vendorId)
            result.success(
                when (status) {
                    false -> 0
                    true -> 1
                    else -> 2
                }
            )
        } catch (e: DidomiNotReadyException) {
            result.error("getUserConsentStatusForVendor", e.message.orEmpty(), e)
        }
    }

    /**
     * Check if a vendor has consent for all the purposes that it requires
     * @param vendorId
     * @return The user consent status for all the purposes that it requires for the specified vendor
     */
    private fun getUserConsentStatusForVendorAndRequiredPurposes(call: MethodCall, result: Result) {
        val vendorId = call.argument("vendorId") as? String
        if (vendorId.isNullOrBlank()) {
            result.error("getUserConsentStatusForVendorAndRequiredPurposes", "vendorId is null or blank", null)
            return
        }
        try {
            val status = Didomi.getInstance().getUserConsentStatusForVendorAndRequiredPurposes(vendorId)
            result.success(
                when (status) {
                    false -> 0
                    true -> 1
                    else -> 2
                }
            )
        } catch (e: DidomiNotReadyException) {
            result.error("getUserConsentStatusForVendorAndRequiredPurposes", e.message.orEmpty(), e)
        }
    }

    /**
     * Get the user legitimate interest status for a specific purpose
     * @param purposeId
     * @return The user legitimate interest status for the specified purpose
     */
    private fun getUserLegitimateInterestStatusForPurpose(call: MethodCall, result: Result) {
        val purposeId = call.argument("purposeId") as? String
        if (purposeId.isNullOrBlank()) {
            result.error("getUserLegitimateInterestStatusForPurpose", "purposeId is null or blank", null)
            return
        }
        try {
            val status = Didomi.getInstance().getUserLegitimateInterestStatusForPurpose(purposeId)
            result.success(
                    when (status) {
                        false -> 0
                        true -> 1
                        else -> 2
                    }
            )
        } catch (e: DidomiNotReadyException) {
            result.error("getUserLegitimateInterestStatusForPurpose", e.message.orEmpty(), e)
        }
    }

    /**
     * Get the user legitimate interest status for a specific vendor
     * @param vendorId
     * @return The user legitimate interest status for the specified vendor
     */
    private fun getUserLegitimateInterestStatusForVendor(call: MethodCall, result: Result) {
        val vendorId = call.argument("vendorId") as? String
        if (vendorId.isNullOrBlank()) {
            result.error("getUserLegitimateInterestStatusForVendor", "vendorId is null or blank", null)
            return
        }
        try {
            val status = Didomi.getInstance().getUserLegitimateInterestStatusForVendor(vendorId)
            result.success(
                    when (status) {
                        false -> 0
                        true -> 1
                        else -> 2
                    }
            )
        } catch (e: DidomiNotReadyException) {
            result.error("getUserLegitimateInterestStatusForVendor", e.message.orEmpty(), e)
        }
    }

    /**
     * Check if a vendor has legitimate interest for all the purposes that it requires
     * @param vendorId
     * @return The user legitimate interest status for all the purposes that it requires for the specified vendor
     */
    private fun getUserLegitimateInterestStatusForVendorAndRequiredPurposes(call: MethodCall, result: Result) {
        val vendorId = call.argument("vendorId") as? String
        if (vendorId.isNullOrBlank()) {
            result.error("getUserLegitimateInterestStatusForVendorAndRequiredPurposes", "vendorId is null or blank", null)
            return
        }
        try {
            val status = Didomi.getInstance().getUserLegitimateInterestStatusForVendorAndRequiredPurposes(vendorId)
            result.success(
                    when (status) {
                        false -> 0
                        true -> 1
                    }
            )
        } catch (e: DidomiNotReadyException) {
            result.error("getUserLegitimateInterestStatusForVendorAndRequiredPurposes", e.message.orEmpty(), e)
        }
    }

    /**
     * Get the user consent and legitimate interest status for a specific vendor
     * @param vendorId
     * @return The user consent and legitimate interest status for the specified vendor
     */
    private fun getUserStatusForVendor(call: MethodCall, result: Result) {
        val vendorId = call.argument("vendorId") as? String
        if (vendorId.isNullOrBlank()) {
            result.error("getUserStatusForVendor", "vendorId is null or blank", null)
            return
        }
        try {
            val status = Didomi.getInstance().getUserStatusForVendor(vendorId)
            result.success(
                    when (status) {
                        false -> 0
                        true -> 1
                    }
            )
        } catch (e: DidomiNotReadyException) {
            result.error("getUserStatusForVendor", e.message.orEmpty(), e)
        }
    }

    /**
     * Set the user status globally
     * @return true if user consent status was updated, false otherwise.
     */
    private fun setUserStatusGlobally(call: MethodCall, result: Result) {
        try {
            val consentHasBeenUpdated = Didomi.getInstance().setUserStatus(
                call.argument("purposesConsentStatus") as? Boolean ?: false,
                call.argument("purposesLIStatus") as? Boolean ?: false,
                call.argument("vendorsConsentStatus") as? Boolean ?: false,
                call.argument("vendorsLIStatus") as? Boolean ?: false
            )
            result.success(consentHasBeenUpdated)
        } catch (e: DidomiNotReadyException) {
            result.error("setUserStatus", e.message.orEmpty(), e)
        }
    }

    /**
     * Set the user status
     * @return true if user consent status was updated, false otherwise.
     */
    private fun setUserStatus(call: MethodCall, result: Result) {
        try {
            val consentHasBeenUpdated = Didomi.getInstance().setUserStatus(
                    getListArgAsSet(call, "enabledConsentPurposeIds"),
                    getListArgAsSet(call, "disabledConsentPurposeIds"),
                    getListArgAsSet(call, "enabledLIPurposeIds"),
                    getListArgAsSet(call, "disabledLIPurposeIds"),
                    getListArgAsSet(call, "enabledConsentVendorIds"),
                    getListArgAsSet(call, "disabledConsentVendorIds"),
                    getListArgAsSet(call, "enabledLIVendorIds"),
                    getListArgAsSet(call, "disabledLIVendorIds")
            )
            result.success(consentHasBeenUpdated)
        } catch (e: DidomiNotReadyException) {
            result.error("setUserStatus", e.message.orEmpty(), e)
        }
    }

    private fun getListArgAsSet(call: MethodCall, key: String) =
            (call.argument(key) as? List<String>)?.toSet() ?: emptySet()

    private fun setUser(call: MethodCall, result: Result) {
        val userId = argumentOrError("organizationUserId", "setUser", call, result)
                ?: return
        Didomi.getInstance().setUser(userId)
        result.success(null)
    }

    private fun setUserWithAuthentication(call: MethodCall, result: Result) {
        val methodName = "setUserWithAuthentication"
        val userId = argumentOrError("organizationUserId", methodName, call, result)
                ?: return
        val organizationUserIdAuthAlgorithm = argumentOrError("organizationUserIdAuthAlgorithm", methodName, call, result)
                ?: return
        val organizationUserIdAuthSid = argumentOrError("organizationUserIdAuthSid", methodName, call, result)
                ?: return
        val organizationUserIdAuthDigest = argumentOrError("organizationUserIdAuthDigest", methodName, call, result)
                ?: return
        Didomi.getInstance().setUser(userId,
                organizationUserIdAuthAlgorithm,
                organizationUserIdAuthSid,
                call.argument("organizationUserIdAuthSalt") as? String,
                organizationUserIdAuthDigest
        )
        result.success(null)
    }

    /**
     * Return the requested argument as non-empty String, or raise an error in result and return null
     */
    private fun argumentOrError(argumentName: String, methodName: String, call: MethodCall, result: Result): String? {
        val argument = call.argument(argumentName) as? String
        if (argument.isNullOrBlank()) {
            result.error(methodName, "$argumentName is null or blank", null)
            return null
        }
        return argument
    }
}
