package io.didomi.didomi_sdk

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import io.didomi.sdk.Didomi
import io.didomi.sdk.Log
import io.didomi.sdk.events.EventListener
import io.didomi.sdk.events.HideNoticeEvent

class DidomiActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        Log.d("!!!!! Activity Create OK")
        super.onCreate(savedInstanceState)
        Didomi.getInstance().also {
            it.addEventListener(object : EventListener() {
                override fun hideNotice(event: HideNoticeEvent?) {
                    Log.d("!!!!! Notice hidden")
                    finish()
                }
            })
            it.setupUI(this)
        }
    }
}