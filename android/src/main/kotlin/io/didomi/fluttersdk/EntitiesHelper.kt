package io.didomi.fluttersdk

import com.google.gson.Gson
import com.google.gson.JsonParseException
import io.didomi.sdk.models.CurrentUserStatus
import java.util.*

// Class used to convert Didomi entities (Vendor, Purpose) from and to types that can be sent through the Flutter channels.
object EntitiesHelper {
    private val gson = Gson()

    // Convert a set of objects into a list of maps.
    @kotlin.jvm.JvmName("toListOfPurposes")
    @Throws(JsonParseException::class)
    fun toList(entities: Set<Any>): List<*> {
        val json = gson.toJsonTree(entities)
        return gson.fromJson(json, List::class.java)
    }

    // Convert an object into a map.
    @Throws(JsonParseException::class)
    fun toMap(sourceObject: Any?): HashMap<*, *>? {
        val valid = sourceObject ?: return null
        val json = gson.toJsonTree(valid)
        return gson.fromJson(json, HashMap::class.java)
    }

    /** Convert Map into PurposeStatus. */
    fun toPurposeStatus(map: Map<*, *>) = CurrentUserStatus.PurposeStatus(
        map["id"] as String,
        map["enabled"] as Boolean
    )

    /** Convert Map into VendorStatus. */
    fun toVendorStatus(map: Map<*, *>) = CurrentUserStatus.VendorStatus(
        map["id"] as String,
        map["enabled"] as Boolean
    )
}
