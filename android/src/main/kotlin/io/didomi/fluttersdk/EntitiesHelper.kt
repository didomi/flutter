package io.didomi.fluttersdk

import io.didomi.sdk.Purpose
import io.didomi.sdk.Regulation
import io.didomi.sdk.Vendor
import io.didomi.sdk.apiEvents.Source
import io.didomi.sdk.models.CurrentUserStatus
import io.didomi.sdk.models.UserStatus

/**
 * Class used to convert Didomi entities from and to types that can be sent through the Flutter channels.
 *
 * Entities are mapped field by field (instead of relying on the JSON annotations of the native SDK)
 * so that the keys expected by the Dart entities (`lib/entities/`) don't depend on how the native SDK serializes its models.
 * Null values are omitted, as they were when the entities were serialized with Gson.
 */
object EntitiesHelper {

    /** Convert a set of purposes into a list of maps. */
    @JvmName("toPurposeList")
    fun toList(purposes: Set<Purpose>): List<Map<String, Any?>> = purposes.map { toMap(it) }

    /** Convert a set of vendors into a list of maps. */
    @JvmName("toVendorList")
    fun toList(vendors: Set<Vendor>): List<Map<String, Any?>> = vendors.map { toMap(it) }

    /** Convert a purpose into a map. */
    @JvmName("toNullablePurposeMap")
    fun toMap(purpose: Purpose?): Map<String, Any?>? = purpose?.let { toMap(it) }

    /** Convert a purpose into a map. */
    fun toMap(purpose: Purpose): Map<String, Any?> = mapOf(
        "id" to purpose.id,
        "name" to purpose.name,
        "description" to purpose.descriptionText,
    )

    /** Convert a vendor into a map. */
    @JvmName("toNullableVendorMap")
    fun toMap(vendor: Vendor?): Map<String, Any?>? = vendor?.let { toMap(it) }

    /** Convert a vendor into a map. */
    fun toMap(vendor: Vendor): Map<String, Any?> = buildMap {
        put("id", vendor.id)
        put("name", vendor.name)
        vendor.namespaces?.let { put("namespaces", toMap(it)) }
        vendor.policyUrl?.let { put("policyUrl", it) }
        put("purposeIds", vendor.purposeIds)
        put("legIntPurposeIds", vendor.legIntPurposeIds)
        put("featureIds", vendor.featureIds)
        put("flexiblePurposeIds", vendor.flexiblePurposeIds)
        put("specialFeatureIds", vendor.specialFeatureIds)
        put("specialPurposeIds", vendor.specialPurposeIds)
        vendor.urls?.let { urls -> put("urls", urls.map { toMap(it) }) }
        put("isIAB", vendor.isIAB)
    }

    private fun toMap(namespaces: Vendor.Namespaces): Map<String, Any?> = buildMap {
        namespaces.iab2?.let { put("iab2", it) }
        namespaces.num?.let { put("num", it) }
        namespaces.didomi?.let { put("didomi", it) }
        namespaces.sp?.let { put("sp", it) }
    }

    private fun toMap(url: Vendor.Url): Map<String, Any?> = buildMap {
        url.langId?.let { put("langId", it) }
        url.privacy?.let { put("privacy", it) }
        url.legIntClaim?.let { put("legIntClaim", it) }
    }

    /** Convert the current user status into a map. */
    fun toMap(status: CurrentUserStatus): Map<String, Any?> = buildMap {
        put("user_id", status.userId)
        put("created", status.created)
        put("updated", status.updated)
        put("consent_string", status.consentString)
        put("addtl_consent", status.additionalConsent)
        put("didomi_dcs", status.didomiDcs)
        put("gpp_string", status.gppString)
        // Regulation of the status object ("custom" for a regulation configuration, the configuration contains the regulation name)
        put("regulation", status.regulation.value)
        put("regulation_configuration", toMap(status.regulationConfiguration))
        put("purposes", status.purposes.mapValues { (_, purposeStatus) -> toMap(purposeStatus) })
        put("vendors", status.vendors.mapValues { (_, vendorStatus) -> toMap(vendorStatus) })
        status.widget?.let { put("widget", toMap(it)) }
    }

    /** Convert a purpose status into a map. */
    fun toMap(purposeStatus: CurrentUserStatus.PurposeStatus): Map<String, Any?> = mapOf(
        "id" to purposeStatus.id,
        "enabled" to purposeStatus.enabled,
    )

    /** Convert a vendor status into a map. */
    fun toMap(vendorStatus: CurrentUserStatus.VendorStatus): Map<String, Any?> = mapOf(
        "id" to vendorStatus.id,
        "enabled" to vendorStatus.enabled,
    )

    /** Convert the widget that collected the consent into a map (null values are kept, as in the native SDK). */
    fun toMap(widget: Source.Widget): Map<String, Any?> = mapOf(
        "type" to widget.type,
        "id" to widget.id,
        "version_id" to widget.versionId,
    )

    /** Convert the user status into a map. */
    fun toMap(status: UserStatus): Map<String, Any?> = mapOf(
        "purposes" to toMap(status.purposes),
        "vendors" to toMap(status.vendors),
        "user_id" to status.userId,
        "created" to status.created,
        "updated" to status.updated,
        "consent_string" to status.consentString,
        "addtl_consent" to status.additionalConsent,
        "didomi_dcs" to status.didomiDcs,
        // The native SDK sets the regulation from `Regulation.value`, which `Regulation.fromString` maps back for every regulation except CUSTOM
        "regulation" to (status.regulation?.value ?: Regulation.CUSTOM.value),
    )

    private fun toMap(purposes: UserStatus.Purposes): Map<String, Any?> = mapOf(
        "global" to toMap(purposes.global),
        "consent" to toMap(purposes.consent),
        "legitimate_interest" to toMap(purposes.legitimateInterest),
        "essential" to purposes.essential.toList(),
    )

    private fun toMap(vendors: UserStatus.Vendors): Map<String, Any?> = mapOf(
        "global" to toMap(vendors.global),
        "global_consent" to toMap(vendors.globalConsent),
        "global_li" to toMap(vendors.globalLegitimateInterest),
        "consent" to toMap(vendors.consent),
        "legitimate_interest" to toMap(vendors.legitimateInterest),
    )

    private fun toMap(ids: UserStatus.Ids): Map<String, Any?> = mapOf(
        "disabled" to ids.disabled.toList(),
        "enabled" to ids.enabled.toList(),
    )

    /** Convert a regulation configuration into a map (built field by field to keep null values and the numerical id as an integer). */
    fun toMap(configuration: Regulation.Configuration?): Map<String, Any?>? {
        val valid = configuration ?: return null
        return mapOf(
            "id" to valid.id,
            "versionId" to valid.versionId,
            "numericalId" to valid.numericalId,
            "regulationName" to valid.regulationName,
            "tokenStorageName" to valid.tokenStorageName,
            "mixed" to valid.mixed
        )
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
