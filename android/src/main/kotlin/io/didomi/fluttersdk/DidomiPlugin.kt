package io.didomi.fluttersdk

import android.app.Activity
import androidx.fragment.app.FragmentActivity
import io.didomi.sdk.Didomi
import io.didomi.sdk.Log
import io.didomi.sdk.DidomiInitializeParameters
import io.didomi.sdk.DidomiUserParameters
import io.didomi.sdk.DidomiMultiUserParameters
import io.didomi.sdk.exceptions.DidomiNotReadyException
import io.didomi.sdk.models.CurrentUserStatus
import io.didomi.sdk.user.model.*
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

    private val vendorStatusListeners = mutableSetOf<String>()

    /// The Activity used to interact with the Didomi SDK.
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

                "initializeWithParameters" -> initializeWithParameters(call, result)

                "isReady" -> result.success(didomi.isReady)

                "onReady" -> didomi.onReady {
                    eventStreamHandler.onReadyCallback()
                }

                "onError" -> didomi.onError {
                    eventStreamHandler.onErrorCallback()
                }

                "shouldConsentBeCollected" -> result.success(didomi.shouldConsentBeCollected())

                "shouldUserStatusBeCollected" -> result.success(didomi.shouldUserStatusBeCollected())

                "isConsentRequired" -> result.success(didomi.isConsentRequired)

                "isUserConsentStatusPartial" -> result.success(didomi.isUserConsentStatusPartial)

                "isUserLegitimateInterestStatusPartial" -> result.success(didomi.isUserLegitimateInterestStatusPartial)

                "isUserStatusPartial" -> result.success(didomi.isUserStatusPartial)

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

                "isNoticeVisible" -> result.success(didomi.isNoticeVisible())

                "showPreferences" -> showPreferences(call, result)

                "hidePreferences" -> {
                    didomi.hidePreferences()
                    result.success(null)
                }

                "isPreferencesVisible" -> result.success(didomi.isPreferencesVisible())

                "getJavaScriptForWebView" -> getJavaScriptForWebView(result)

                "getQueryStringForWebView" -> result.success(didomi.queryStringForWebView)

                "updateSelectedLanguage" -> updateSelectedLanguage(call, result)

                "getText" -> getText(call, result)

                "getTranslatedText" -> getTranslatedText(call, result)

                "getCurrentUserStatus" -> getCurrentUserStatus(result)

                "setCurrentUserStatus" -> setCurrentUserStatus(call, result)

                "getUserStatus" -> getUserStatus(result)

                "getApplicableRegulation" -> getApplicableRegulation(result)

                "getRequiredPurposeIds" -> getRequiredPurposeIds(result)

                "getRequiredVendorIds" -> getRequiredVendorIds(result)

                "getRequiredPurposes" -> getRequiredPurposes(result)

                "getRequiredVendors" -> getRequiredVendors(result)

                "getPurpose" -> getPurpose(call, result)

                "getVendor" -> getVendor(call, result)

                "setLogLevel" -> setLogLevel(call, result)

                "setUserAgreeToAll" -> setUserAgreeToAll(result)

                "setUserDisagreeToAll" -> setUserDisagreeToAll(result)

                "setUserStatus" -> setUserStatus(call, result)

                "setUserStatusGlobally" -> setUserStatusGlobally(call, result)

                "clearUser" -> clearUser(call, result)

                "setUser" -> setUser(call, result)

                "setUserAndSetupUI" -> setUserAndSetupUI(call, result)

                "setUserWithAuthParams" -> setUserWithAuthParams(call, result)

                "setUserWithAuthParamsAndSetupUI" -> setUserWithAuthParamsAndSetupUI(call, result)

                "setUserWithParameters" -> setUserWithParameters(call, result)

                "setUserWithParametersAndSetupUI" -> setUserWithParametersAndSetupUI(call, result)

                "listenToVendorStatus" -> listenToVendorStatus(call, result)

                "stopListeningToVendorStatus" -> stopListeningToVendorStatus(call, result)

                "commitCurrentUserStatusTransaction" -> commitCurrentUserStatusTransaction(call, result)

                "executeSyncAcknowledgedCallback" -> executeSyncAcknowledgedCallback(call, result)

                "getTotalVendorCount" -> getTotalVendorCount(result)

                "getIabVendorCount" -> getIabVendorCount(result)

                "getNonIabVendorCount" -> getNonIabVendorCount(result)

                else -> result.notImplemented()
            }
        } catch (e: Exception) {
            result.error("didomi_exception", e.message, e)
        }
    }

    private fun initialize(call: MethodCall, result: Result) {
        currentActivity?.also {
            val apiKey = argumentOrError("apiKey", "initialize", call, result) ?: return
            val disableDidomiRemoteConfig: Boolean = call.argument("disableDidomiRemoteConfig") ?: false
            val androidTvEnabled: Boolean = call.argument("androidTvEnabled") ?: false
            val isUnderage: Boolean = call.argument("isUnderage") ?: false
            Didomi.getInstance().initialize(
                it.application,
                DidomiInitializeParameters(
                    apiKey = apiKey,
                    localConfigurationPath = call.argument("localConfigurationPath"),
                    remoteConfigurationUrl = call.argument("remoteConfigurationURL"),
                    providerId = call.argument("providerId"),
                    disableDidomiRemoteConfig = disableDidomiRemoteConfig,
                    languageCode = call.argument("languageCode"),
                    noticeId = call.argument("noticeId"),
                    tvNoticeId = call.argument("androidTvNoticeId"),
                    androidTvEnabled = androidTvEnabled,
                    countryCode = call.argument("countryCode"),
                    regionCode = call.argument("regionCode"),
                    isUnderage = isUnderage
                )
            )
            result.success(null)
        } ?: run {
            result.error("no_activity", "No activity available", null)
        }
    }

    private fun initializeWithParameters(call: MethodCall, result: Result) {
        val jsonDidomiInitializeParameters = call.argument("jsonDidomiInitializeParameters") as? Map<String, Any>
        if (jsonDidomiInitializeParameters == null) {
            result.error("initializeWithParameters", "Missing parameter", null)
            return
        }

        currentActivity?.also {
            val didomiInitializeParameters = DidomiInitializeParameters(
                apiKey = jsonDidomiInitializeParameters["apiKey"] as String,
                localConfigurationPath = jsonDidomiInitializeParameters["localConfigurationPath"] as? String,
                remoteConfigurationUrl = jsonDidomiInitializeParameters["remoteConfigurationUrl"] as? String,
                providerId = jsonDidomiInitializeParameters["providerId"] as? String,
                disableDidomiRemoteConfig = jsonDidomiInitializeParameters["disableDidomiRemoteConfig"] as Boolean,
                languageCode = jsonDidomiInitializeParameters["languageCode"] as? String,
                noticeId = jsonDidomiInitializeParameters["noticeId"] as? String,
                tvNoticeId = jsonDidomiInitializeParameters["androidTvNoticeId"] as? String,
                androidTvEnabled = jsonDidomiInitializeParameters["androidTvEnabled"] as Boolean,
                countryCode = jsonDidomiInitializeParameters["countryCode"] as? String,
                regionCode = jsonDidomiInitializeParameters["regionCode"] as? String,
                isUnderage = jsonDidomiInitializeParameters["isUnderage"] as Boolean,
            )

            Didomi.getInstance().initialize(it.application, didomiInitializeParameters)
            result.success(null)
        } ?: run {
            result.error("initializeWithParameters", "No activity available", null)
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
            val languageCode: String? = call.argument("languageCode")
            Didomi.getInstance().updateSelectedLanguage(languageCode.orEmpty())
            result.success(null)
        } catch (e: DidomiNotReadyException) {
            result.error("updateSelectedLanguage", e.message.orEmpty(), e)
        }
    }

    private fun getText(call: MethodCall, result: Result) {
        try {
            val key: String? = call.argument("key")
            val textMap = Didomi.getInstance().getText(key.orEmpty())
            result.success(textMap)
        } catch (e: DidomiNotReadyException) {
            result.error("getText", e.message.orEmpty(), e)
        }
    }

    private fun getTranslatedText(call: MethodCall, result: Result) {
        try {
            val key: String? = call.argument("key")
            val text = Didomi.getInstance().getTranslatedText(key.orEmpty())
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
            val text = Didomi.getInstance().getJavaScriptForWebView()
            result.success(text)
        } catch (e: DidomiNotReadyException) {
            result.error("getJavaScriptForWebView", e.message.orEmpty(), e)
        }
    }

    /**
     * Get the CurrentUserStatus object
     */
    private fun getCurrentUserStatus(result: Result) {
        try {
            val currentUserStatus = Didomi.getInstance().currentUserStatus
            val map = EntitiesHelper.toMap(currentUserStatus)
            result.success(map)
        } catch (e: DidomiNotReadyException) {
            result.error("getCurrentUserStatus", e.message.orEmpty(), e)
        }
    }

    /**
     * Set the CurrentUserStatus object
     */
    private fun setCurrentUserStatus(call: MethodCall, result: Result) {
        val map = call.arguments as? Map<*, *>
        map?.also {
            val purposes = (it["purposes"] as? Map<String, Map<*, *>>)?.mapValues { (_, value) ->
                EntitiesHelper.toPurposeStatus(value)
            }
            val vendors = (it["vendors"] as? Map<String, Map<*, *>>)?.mapValues { (_, value) ->
                EntitiesHelper.toVendorStatus(value)
            }

            val currentUserStatus = CurrentUserStatus(
                purposes = purposes ?: emptyMap(),
                vendors = vendors ?: emptyMap(),
            )

            try {
                val statusSet = Didomi.getInstance().setCurrentUserStatus(currentUserStatus)
                result.success(statusSet)
            } catch (e: DidomiNotReadyException) {
                result.error("setCurrentUserStatus", e.message.orEmpty(), e)
            }
        } ?: run {
            result.error("setCurrentUserStatus", "Missing arguments", null)
        }
    }

    /**
     * Get the UserStatus object
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
     * Get the applicable regulation
     */
    private fun getApplicableRegulation(result: Result) {
        try {
            val regulation = Didomi.getInstance().applicableRegulation
            result.success(regulation.value)
        } catch (e: DidomiNotReadyException) {
            result.error("getApplicableRegulation", e.message.orEmpty(), e)
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
            val purpose = Didomi.getInstance().getPurpose(id.orEmpty())
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
            val vendor = Didomi.getInstance().getVendor(id.orEmpty())
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

    private fun getListArgAsSet(call: MethodCall, key: String) = (call.argument(key) as? List<String>)?.toSet() ?: emptySet()

    /**
     * Clear user
     */
    private fun clearUser(call: MethodCall, result: Result) {
        eventStreamHandler.clearSyncReadyEventReferences();
        Didomi.getInstance().clearUser()
        result.success(null)
    }

    /**
     * Set Organisation User ID and optional underage flag
     */
    private fun setUser(call: MethodCall, result: Result) {
        val organizationUserId = argumentOrError("organizationUserId", "setUser", call, result) ?: return

        val didomiUserParameters = DidomiUserParameters(
            userAuth = UserAuthWithoutParams(organizationUserId),
            isUnderage = call.argument("isUnderage")
        )

        Didomi.getInstance().setUser(parameters = didomiUserParameters)

        result.success(null)
    }

    /**
     * Set Organisation User ID and optional underage flag with activity
     */
    private fun setUserAndSetupUI(call: MethodCall, result: Result) {
        val organizationUserId = argumentOrError("organizationUserId", "setUser", call, result) ?: return

        val didomiUserParameters = DidomiUserParameters(
            userAuth = UserAuthWithoutParams(organizationUserId),
            activity = getFragmentActivity(result),
            isUnderage = call.argument("isUnderage")
        )

        Didomi.getInstance().setUser(parameters = didomiUserParameters)

        result.success(null)
    }

    /**
     * Build UserAuth object from JSON
     * @param jsonParameters the JSON parameters
     * @return UserAuth object (UserAuthWithoutParams or UserAuthWithHashParams or UserAuthWithEncryptionParams)
     */
    private fun buildUserAuth(jsonParameters: Map<String, Any>): UserAuth = buildUserAuthParams(jsonParameters)
        ?: UserAuthWithoutParams(id = jsonParameters["id"] as String)

    /**
     * Build UserAuthParams object (with encryption or hash) from JSON
     * @param jsonParameters the JSON parameters
     * @return UserAuthParams object (UserAuthWithHashParams or UserAuthWithEncryptionParams) or null
     */
    private fun buildUserAuthParams(jsonParameters: Map<String, Any>?): UserAuthParams? {

        if (jsonParameters.isNullOrEmpty()) {
            return null
        }

        val id = jsonParameters["id"] as? String ?: return null
        val algorithm = jsonParameters["algorithm"] as? String ?: return null
        val secretId = jsonParameters["secretId"] as? String ?: return null
        val expiration = jsonParameters["expiration"] as? Int
        val initializationVector = jsonParameters["initializationVector"] as? String
        val digest = jsonParameters["digest"] as? String
        val salt = jsonParameters["salt"] as? String

        return when {
            // Encryption
            !digest.isNullOrBlank() -> UserAuthWithHashParams(
                id = id,
                algorithm = algorithm,
                secretId = secretId,
                digest = digest,
                salt = salt,
                expiration = expiration?.toLong()
            )
            // Hash
            !initializationVector.isNullOrBlank() -> UserAuthWithEncryptionParams(
                id = id,
                algorithm = algorithm,
                secretId = secretId,
                initializationVector = initializationVector,
                expiration = expiration?.toLong()
            )

            else -> null
        }
    }

    /**
     * Build DidomiUserParameters from JSON and optional activity
     * @param jsonParameters the JSON parameters
     * @param activity the optional [FragmentActivity]
     * @return the DidomiUserParameters object (as [DidomiUserParameters] or [DidomiMultiUserParameters])
     */
    private fun buildDidomiUserParameters(
        jsonParameters: Map<String, Any>,
        activity: FragmentActivity? = null
    ): DidomiUserParameters {

        val userAuth = jsonParameters["userAuth"] as Map<String, Any>
        val dcsUserAuth = jsonParameters["dcsUserAuth"] as? Map<String, Any>
        val synchronizedUsers = jsonParameters["synchronizedUsers"] as? List<Map<String, Any>>
        val isUnderage = jsonParameters["isUnderage"] as? Boolean

        return if (synchronizedUsers == null) {
            DidomiUserParameters(
                userAuth = buildUserAuth(userAuth),
                dcsUserAuth = buildUserAuthParams(dcsUserAuth),
                activity = activity,
                isUnderage = isUnderage,
            )
        } else {
            DidomiMultiUserParameters(
                userAuth = buildUserAuth(userAuth),
                dcsUserAuth = buildUserAuthParams(dcsUserAuth),
                synchronizedUsers = synchronizedUsers.mapNotNull { buildUserAuthParams(it) }.toTypedArray(),
                activity = activity,
                isUnderage = isUnderage,
            )
        }
    }

    /**
     * Set Organisation User Auth and optional underage flag
     */
    private fun setUserWithAuthParams(call: MethodCall, result: Result) {
        val jsonUserAuthParams = call.argument("jsonUserAuthParams") as? Map<String, Any>
        if (jsonUserAuthParams == null) {
            result.error("setUser", "Missing parameters", null)
            return
        }

        val jsonSynchronizedUsers = call.argument("jsonSynchronizedUsers") as? List<Map<String, Any>>
        val isUnderage = call.argument("isUnderage") as? Boolean

        val didomiUserParameters = if (jsonSynchronizedUsers == null) {
            DidomiUserParameters(
                userAuth = buildUserAuth(jsonUserAuthParams),
                isUnderage = isUnderage
            )
        } else {
            DidomiMultiUserParameters(
                userAuth = buildUserAuth(jsonUserAuthParams),
                synchronizedUsers = jsonSynchronizedUsers.mapNotNull { buildUserAuthParams(it) }.toTypedArray(),
                isUnderage = isUnderage
            )
        }

        Didomi.getInstance().setUser(parameters = didomiUserParameters)

        result.success(null)
    }

    /**
     * Set Organisation User Auth and optional underAge flag with activity
     */
    private fun setUserWithAuthParamsAndSetupUI(call: MethodCall, result: Result) {
        val jsonUserAuthParams = call.argument("jsonUserAuthParams") as? Map<String, Any>
        if (jsonUserAuthParams == null) {
            result.error("setUser", "Missing parameters", null)
            return
        }

        val jsonSynchronizedUsers = call.argument("jsonSynchronizedUsers") as? List<Map<String, Any>>
        val isUnderage = call.argument("isUnderage") as? Boolean

        val didomiUserParameters = if (jsonSynchronizedUsers == null) {
            DidomiUserParameters(
                userAuth = buildUserAuth(jsonUserAuthParams),
                activity = getFragmentActivity(result),
                isUnderage = isUnderage
            )
        } else {
            DidomiMultiUserParameters(
                userAuth = buildUserAuth(jsonUserAuthParams),
                synchronizedUsers = jsonSynchronizedUsers.mapNotNull { buildUserAuthParams(it) }.toTypedArray(),
                activity = getFragmentActivity(result),
                isUnderage = isUnderage
            )
        }

        Didomi.getInstance().setUser(parameters = didomiUserParameters)

        result.success(null)
    }

    /**
     * Set Didomi User params
     */
    private fun setUserWithParameters(call: MethodCall, result: Result) {
        val jsonDidomiUserParameters = call.argument("jsonDidomiUserParameters") as? Map<String, Any>
        if (jsonDidomiUserParameters == null) {
            result.error("setUser", "Missing parameters", null)
            return
        }

        val didomiUserParameters = buildDidomiUserParameters(jsonDidomiUserParameters)

        Didomi.getInstance().setUser(parameters = didomiUserParameters)

        result.success(null)
    }

    /**
     * Set Didomi User params with activity
     */
    private fun setUserWithParametersAndSetupUI(call: MethodCall, result: Result) {
        val jsonDidomiUserParameters = call.argument("jsonDidomiUserParameters") as? Map<String, Any>
        if (jsonDidomiUserParameters == null) {
            result.error("setUser", "Missing parameters", null)
            return
        }

        val didomiUserParameters = buildDidomiUserParameters(jsonDidomiUserParameters, activity = getFragmentActivity(result))

        Didomi.getInstance().setUser(parameters = didomiUserParameters)

        result.success(null)
    }

    private fun listenToVendorStatus(call: MethodCall, result: Result) {
        val methodName = "listenToVendorStatus"
        val vendorId = argumentOrError("vendorId", methodName, call, result) ?: return

        if (!vendorStatusListeners.contains(vendorId)) {
            Didomi.getInstance().addVendorStatusListener(vendorId) { vendorStatus ->
                eventStreamHandler.onVendorStatusChanged(vendorStatus)
            }
            vendorStatusListeners.add(vendorId)
        }
        result.success(null)
    }

    private fun stopListeningToVendorStatus(call: MethodCall, result: Result) {
        val methodName = "stopListeningToVendorStatus"
        val vendorId = argumentOrError("vendorId", methodName, call, result) ?: return

        vendorStatusListeners.remove(vendorId)
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

    /**
     * Here all the changes to the user status related to purposes and vendors are applied and committed at once.
     */
    private fun commitCurrentUserStatusTransaction(call: MethodCall, result: Result) {
        try {
            val enabledPurposes = argumentAsArray("enabledPurposes", call)
            val disabledPurposes = argumentAsArray("disabledPurposes", call)
            val enabledVendors = argumentAsArray("enabledVendors", call)
            val disabledVendors = argumentAsArray("disabledVendors", call)

            val updated = Didomi.getInstance().openCurrentUserStatusTransaction()
                .enablePurposes(*enabledPurposes)
                .disablePurposes(*disabledPurposes)
                .enableVendors(*enabledVendors)
                .disableVendors(*disabledVendors)
                .commit()

            result.success(updated)

        } catch (e: DidomiNotReadyException) {
            result.error("openCurrentUserStatusTransaction", e.message.orEmpty(), e)
        }
    }

    // Execute the syncAcknowledgedCallback method of the Didomi SDK
    private fun executeSyncAcknowledgedCallback(call: MethodCall, result: Result) {
        try {
            val syncReadyEventIndex = call.argument("syncReadyEventIndex") as? Int
            syncReadyEventIndex?.also {
                result.success(eventStreamHandler.executeSyncAcknowledgedCallback(it))
            } ?: run {
                result.error("executeSyncAcknowledgedCallback", "Missing argument syncReadyEventIndex", null)
            }

        } catch (e: DidomiNotReadyException) {
            result.error("executeSyncAcknowledgedCallback", e.message.orEmpty(), e)
        }
    }

    /**
     * Get the number of vendors
     */
    private fun getTotalVendorCount(result: Result) {
        try {
            val count = Didomi.getInstance().getTotalVendorCount()
            result.success(count)
        } catch (e: DidomiNotReadyException) {
            result.error("getTotalVendorCount", e.message.orEmpty(), e)
        }
    }

    /**
     * Get the number of IAB vendors
     */
    private fun getIabVendorCount(result: Result) {
        try {
            val count = Didomi.getInstance().getIabVendorCount()
            result.success(count)
        } catch (e: DidomiNotReadyException) {
            result.error("getIabVendorCount", e.message.orEmpty(), e)
        }
    }

    /**
     * Get the number of non-IAB vendors
     */
    private fun getNonIabVendorCount(result: Result) {
        try {
            val count = Didomi.getInstance().getNonIabVendorCount()
            result.success(count)
        } catch (e: DidomiNotReadyException) {
            result.error("getNonIabVendorCount", e.message.orEmpty(), e)
        }
    }


    private fun argumentAsArray(argumentName: String, call: MethodCall): Array<String> {
        val argument = call.argument<List<String>?>(argumentName)
        val array = argument?.toTypedArray()

        if (array.isNullOrEmpty()) {
            return emptyArray()
        }

        return array
    }
}
