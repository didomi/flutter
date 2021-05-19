package io.didomi.fluttersdk

import android.app.Activity
import androidx.annotation.NonNull
import androidx.fragment.app.FragmentActivity
import io.didomi.sdk.Didomi
import io.didomi.sdk.Log
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

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        // TODO Remove this / Expose log methods
        Log.level = android.util.Log.VERBOSE

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

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
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

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        try {
            when (call.method) {

                "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")

                "initialize" -> initializeSdk(call, result)

                "setupUI" -> {
                    getFragmentActivity(result)?.also {
                        Didomi.getInstance().setupUI(it)
                        result.success(null)
                    }
                }

                "isReady" -> result.success(Didomi.getInstance().isReady)

                "onReady" -> Didomi.getInstance().onReady {
                    eventStreamHandler.onReadyCallback()
                }

                "onError" -> Didomi.getInstance().onError {
                    eventStreamHandler.onErrorCallback()
                }

                "shouldConsentBeCollected" -> result.success(Didomi.getInstance().shouldConsentBeCollected())

                "reset" -> {
                    Didomi.getInstance().reset()
                    result.success(null)
                }

                "showPreferences" -> {
                    getFragmentActivity(result)?.also {
                        Didomi.getInstance().showPreferences(it)
                        result.success(null)
                    }
                }

                "hideNotice" -> {
                    Didomi.getInstance().hideNotice()
                    result.success(null)
                }

                "getDisabledPurposeIds" -> getDisabledPurposeIds(result)

                "getDisabledVendorIds" -> getDisabledVendorIds(result)

                "getEnabledPurposeIds" -> getEnabledPurposeIds(result)

                "getEnabledVendorIds" -> getEnabledVendorIds(result)

                "getRequiredPurposeIds" -> getRequiredPurposeIds(result)

                "getRequiredVendorIds" -> getRequiredVendorIds(result)

                "setLogLevel" -> setLogLevel(call, result)

                "setUserAgreeToAll" -> setUserAgreeToAll(result)

                "setUserDisagreeToAll" -> setUserDisagreeToAll(result)

                "getUserConsentStatusForVendor" -> getUserConsentStatusForVendor(call, result)

                "setUserStatus" -> setUserStatus(call, result)

                else -> result.notImplemented()
            }
        } catch (e: Exception) {
            result.error("didomi_exception", "An error occured: ${e.message}", e)
        }
    }

    private fun initializeSdk(call: MethodCall, result: Result) {
        currentActivity?.also {
            Didomi.getInstance().initialize(
                it.application,
                call.argument("apiKey"),
                call.argument("localConfigurationPath"),
                call.argument("remoteConfigurationURL"),
                call.argument("providerId"),
                call.argument("disableDidomiRemoteConfig"),
                call.argument("languageCode"),
                call.argument("noticeId")
            )
            result.success(null)
        } ?: run {
            result.error("no_activity", "No activity available", null)
        }
    }

    /**
     * Get the current activity as FragmentActivity, or raise an error
     */
    private fun getFragmentActivity(@NonNull result: Result): FragmentActivity? = currentActivity?.let {
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

    /**
     * Get the IDs of the disabled purposes
     */
    private fun getDisabledPurposeIds(@NonNull result: Result) {
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
    private fun getDisabledVendorIds(@NonNull result: Result) {
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
    private fun getEnabledPurposeIds(@NonNull result: Result) {
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
    private fun getEnabledVendorIds(@NonNull result: Result) {
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
    private fun getRequiredPurposeIds(@NonNull result: Result) {
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
    private fun getRequiredVendorIds(@NonNull result: Result) {
        try {
            val idSet = Didomi.getInstance().requiredVendorIds
            result.success(idSet.toList())
        } catch (e: DidomiNotReadyException) {
            result.error("getRequiredVendorIds", e.message.orEmpty(), e)
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
    private fun setLogLevel(@NonNull call: MethodCall, @NonNull result: Result) {
        Didomi.getInstance().setLogLevel(call.argument("minLevel") as? Int ?: 2)
        result.success(null)
    }

    /**
     * Enable all purposes and vendors for the user.
     * @return true if user consent status was updated, false otherwise.
     */
    private fun setUserAgreeToAll(@NonNull result: Result) {
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
    private fun setUserDisagreeToAll(@NonNull result: Result) {
        try {
            val consentHasBeenUpdated = Didomi.getInstance().setUserDisagreeToAll()
            result.success(consentHasBeenUpdated)
        } catch (e: DidomiNotReadyException) {
            result.error("setUserDisagreeToAll", e.message.orEmpty(), e)
        }
    }

    /**
     * Get the user consent status for a specific vendor
     * @param vendorId
     * @return The user consent status for the specified vendor
     */
    private fun getUserConsentStatusForVendor(@NonNull call: MethodCall, @NonNull result: Result) {
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
     * Set the user status globally
     * @return true if user consent status was updated, false otherwise.
     */
    private fun setUserStatus(@NonNull call: MethodCall, @NonNull result: Result) {
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
}
