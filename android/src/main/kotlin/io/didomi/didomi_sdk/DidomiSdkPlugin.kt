package io.didomi.didomi_sdk

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
class DidomiSdkPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  private var currentActivity: Activity? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "didomi_sdk")
    Log.level = android.util.Log.VERBOSE
    Log.e("!!!!!!! ATTACHED")

    channel.setMethodCallHandler(this)
  }

  override fun onAttachedToActivity(activityPluginBinding: ActivityPluginBinding) {
    Log.e("!!!!!!! attached to ACTIVITY")

    activityPluginBinding.activity?.also {
      Log.d("!!!!!! Activity: $it")
      currentActivity = it
      Didomi.getInstance().onReady {
        Log.d("!!!!!!! Should Consent be collected? ${Didomi.getInstance().shouldConsentBeCollected()}")
        if (Didomi.getInstance().shouldConsentBeCollected()) {
          it.startActivity(Intent(it, DidomiActivity::class.java))
        }
      }
    }
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    Log.d("!!!!!!! Calling " + call.method)
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else if (call.method == "initialize") {
      val disableRemote = false
      currentActivity?.also {
        Didomi.getInstance().initialize(
                it.application,
                "b5c8560d-77c7-4b1e-9200-954c0693ae1a",
                null,
                null,
                null,
                disableRemote,
                "NDQxnJbk"
        )
      } ?:run {
        Log.e("!!!!!!! Activity not present ")
      }
    } else if (call.method == "getShouldConsentBeCollected") {
      result.success(Didomi.getInstance().shouldConsentBeCollected())
    } else if (call.method == "resetDidomi") {
      result.success(Didomi.getInstance().reset())
    } else if (call.method == "showPreferences") {
      val fragmentActivity = currentActivity as? FragmentActivity
      if (fragmentActivity != null) {
        Log.d("!!!!!!! Frag Activity OK")
        result.success(Didomi.getInstance().showPreferences(fragmentActivity))
      } else {
        Log.d("!!!!!!! Activity not present for " + call.method)
        result.error("no_activity", "No current activity", null)
      }
    } else {
      Log.d("!!!!!!! Not Found, send Exception -- " + call.method)
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onDetachedFromActivity() {
    // Do nothing
    currentActivity = null
  }

  override fun onDetachedFromActivityForConfigChanges() {
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
  }
}
