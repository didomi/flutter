package io.didomi.fluttersdk

import android.app.Activity
import android.content.Intent
import androidx.annotation.NonNull
import io.didomi.sdk.Didomi
import io.didomi.sdk.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import androidx.fragment.app.FragmentActivity

/** DidomiSdkPlugin */
class DidomiPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    /// The Activity used to interact with the Didomi SDK.
    ///
    /// This is always the current displayed Activity, as activities can not be passed through Flutter channels
    private var currentActivity: Activity? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "didomi_sdk")
        Log.level = android.util.Log.VERBOSE

        channel.setMethodCallHandler(this)
    }

    override fun onAttachedToActivity(activityPluginBinding: ActivityPluginBinding) {
        // Update the current activity
        activityPluginBinding.activity?.also {
            currentActivity = it
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
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

                else -> result.notImplemented()
            }
        } catch(e: Exception) {
            result.error("didomi_exception", "An error occured: ${e.message}", e)
        }
    }

    fun initializeSdk(call: MethodCall, result: Result) {
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

    /// Get the current activity as FragmentActivity, or raise an error
    fun getFragmentActivity(@NonNull result: Result): FragmentActivity? = currentActivity?.let {
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
}