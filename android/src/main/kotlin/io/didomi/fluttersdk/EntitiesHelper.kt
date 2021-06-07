package io.didomi.fluttersdk
import com.google.gson.Gson
import io.didomi.sdk.Purpose
import io.didomi.sdk.Vendor
import java.util.*

// Class used to convert Didomi entities (Vendor, Purpose) from and to types that can be sent through the Flutter channels.
class EntitiesHelper {
    companion object {
        private val gson = Gson()
        
        // Convert a set of purposes into a list of maps.
        @kotlin.jvm.JvmName("toListOfPurposes")
        fun toList(purposes: Set<Purpose>): List<*> {
            val json = gson.toJsonTree(purposes)
            return gson.fromJson(json, List::class.java)
        }

        // Convert a set of vendors into a list of maps.
        @kotlin.jvm.JvmName("toListOfVendors")
        fun toList(vendors: Set<Vendor>): List<*> {
            val json = gson.toJsonTree(vendors)
            return gson.fromJson(json, List::class.java)
        }

        // Convert a purpose into a map.
        fun toMap(purpose: Purpose?): HashMap<*, *>? {
            val valid = purpose ?: return null
            val json = gson.toJsonTree(valid)
            return gson.fromJson(json, HashMap::class.java)
        }

        // Convert a vendor into a map.
        fun toMap(vendor: Vendor?): HashMap<*, *>? {
            val valid = vendor ?: return null
            val json = gson.toJsonTree(valid)
            return gson.fromJson(json, HashMap::class.java)
        }
    }
}
