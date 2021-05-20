package io.didomi.fluttersdk

import android.app.Activity
import androidx.annotation.NonNull
import io.didomi.sdk.Didomi
import io.didomi.sdk.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import androidx.fragment.app.FragmentActivity

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

                "getJavaScriptForWebView" -> result.success(Didomi.getInstance().javaScriptForWebView)

                "getQueryStringForWebView" -> result.success(Didomi.getInstance().queryStringForWebView)

                "updateSelectedLanguage" -> updateSelectedLanguage(call, result)

                "getText" -> getText(call, result)

                "getTranslatedText" -> getTranslatedText(call, result)

                else -> result.notImplemented()
            }
        } catch(e: Exception) {
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

    private fun updateSelectedLanguage(call: MethodCall, result: Result) {
        Didomi.getInstance().updateSelectedLanguage(call.argument("languageCode"))
        result.success(null)
    }

    private fun getText(call: MethodCall, result: Result) {
        val textMap = Didomi.getInstance().getText(call.argument("key"))
        result.success(textMap)
    }

    private fun getTranslatedText(call: MethodCall, result: Result) {
        val text = Didomi.getInstance().getTranslatedText(call.argument("key"))
        result.success(text)
    }
}
