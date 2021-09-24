package io.didomi.fluttersdk
import com.google.gson.Gson
import com.google.gson.JsonParseException
import java.util.*

// Class used to convert Didomi entities (Vendor, Purpose) from and to types that can be sent through the Flutter channels.
class EntitiesHelper {
    companion object {
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
    }
}
