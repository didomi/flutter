package io.didomi.fluttersdk

import io.didomi.sdk.Purpose
import io.didomi.sdk.Regulation
import io.didomi.sdk.Vendor
import io.didomi.sdk.apiEvents.Source
import io.didomi.sdk.models.CurrentUserStatus
import io.didomi.sdk.models.UserStatus
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

/** Keys and value types read by the Dart entities (`lib/entities/`). */
class EntitiesHelperTest {

    @Test
    fun `purpose is mapped with the description key`() {
        val purpose = Purpose(id = "cookies", name = "Cookies", descriptionText = "Purpose description")

        assertEquals(
            mapOf("id" to "cookies", "name" to "Cookies", "description" to "Purpose description"),
            EntitiesHelper.toMap(purpose)
        )
        assertEquals(listOf(EntitiesHelper.toMap(purpose)), EntitiesHelper.toList(setOf(purpose)))
        assertNull(EntitiesHelper.toMap(null as Purpose?))
    }

    @Test
    fun `vendor is mapped with all its fields`() {
        assertEquals(
            mapOf(
                "id" to "vendor-1",
                "name" to "Vendor 1",
                "namespaces" to mapOf("iab2" to "12", "num" to 12, "didomi" to "vendor-1", "sp" to "sp-1"),
                "policyUrl" to "https://vendor.com/policy",
                "purposeIds" to listOf("cookies"),
                "legIntPurposeIds" to listOf("analytics"),
                "featureIds" to listOf("1"),
                "flexiblePurposeIds" to listOf("2"),
                "specialFeatureIds" to listOf("3"),
                "specialPurposeIds" to listOf("4"),
                "urls" to listOf(
                    mapOf("langId" to "en", "privacy" to "https://vendor.com/en/privacy", "legIntClaim" to "https://vendor.com/en/li")
                ),
                "isIAB" to true,
            ),
            EntitiesHelper.toMap(fullVendor())
        )
    }

    @Test
    fun `vendor null fields are omitted`() {
        val vendor = Vendor(
            id = "vendor-2",
            namespaces = Vendor.Namespaces(iab2 = "2"),
            urls = listOf(Vendor.Url(langId = "fr")),
            isIAB = false
        )

        assertEquals(
            mapOf(
                "id" to "vendor-2",
                "name" to "",
                "namespaces" to mapOf("iab2" to "2"),
                "purposeIds" to emptyList<String>(),
                "legIntPurposeIds" to emptyList<String>(),
                "featureIds" to emptyList<String>(),
                "flexiblePurposeIds" to emptyList<String>(),
                "specialFeatureIds" to emptyList<String>(),
                "specialPurposeIds" to emptyList<String>(),
                "urls" to listOf(mapOf("langId" to "fr")),
                "isIAB" to false,
            ),
            EntitiesHelper.toMap(vendor)
        )
        assertEquals(listOf(EntitiesHelper.toMap(vendor)), EntitiesHelper.toList(setOf(vendor)))
        assertNull(EntitiesHelper.toMap(null as Vendor?))
    }

    @Test
    fun `current user status is mapped with the native keys`() {
        assertEquals(
            mapOf(
                "user_id" to "user-id",
                "created" to "2026-01-01T00:00:00.000Z",
                "updated" to "2026-01-02T00:00:00.000Z",
                "consent_string" to "consent-string",
                "addtl_consent" to "1~",
                "didomi_dcs" to "dcs",
                "gpp_string" to "gpp",
                "regulation" to "ccpa",
                "regulation_configuration" to null,
                "purposes" to mapOf("cookies" to mapOf("id" to "cookies", "enabled" to true)),
                "vendors" to mapOf("vendor-1" to mapOf("id" to "vendor-1", "enabled" to false)),
            ),
            EntitiesHelper.toMap(fullCurrentUserStatus())
        )
    }

    @Test
    fun `widget keeps its null values`() {
        assertEquals(
            mapOf("type" to "notice", "id" to "widget-1", "version_id" to "v2"),
            EntitiesHelper.toMap(Source.Widget(type = "notice", id = "widget-1", versionId = "v2"))
        )
        assertEquals(
            mapOf("type" to null, "id" to "widget-1", "version_id" to null),
            EntitiesHelper.toMap(Source.Widget(type = null, id = "widget-1", versionId = null))
        )
    }

    @Test
    fun `vendor status is mapped`() {
        assertEquals(
            mapOf("id" to "vendor-1", "enabled" to true),
            EntitiesHelper.toMap(CurrentUserStatus.VendorStatus(id = "vendor-1", enabled = true))
        )
    }

    @Test
    fun `user status is mapped with the native keys`() {
        assertEquals(
            mapOf(
                "purposes" to mapOf(
                    "global" to ids(enabled = "cookies", disabled = "analytics"),
                    "consent" to ids(enabled = "cookies", disabled = "analytics"),
                    "legitimate_interest" to ids(enabled = "li_purpose", disabled = null),
                    "essential" to listOf("essential_purpose"),
                ),
                "vendors" to mapOf(
                    "global" to ids(enabled = "vendor-1", disabled = "vendor-2"),
                    "global_consent" to ids(enabled = "vendor-1", disabled = null),
                    "global_li" to ids(enabled = null, disabled = "vendor-2"),
                    "consent" to ids(enabled = "vendor-1", disabled = null),
                    "legitimate_interest" to ids(enabled = null, disabled = "vendor-2"),
                ),
                "user_id" to "user-id",
                "created" to "2026-01-01T00:00:00.000Z",
                "updated" to "2026-01-02T00:00:00.000Z",
                "consent_string" to "consent-string",
                "addtl_consent" to "1~",
                "didomi_dcs" to "dcs",
                "regulation" to "gdpr",
            ),
            EntitiesHelper.toMap(fullUserStatus())
        )
    }

    @Test
    fun `user status keeps the custom regulation`() {
        val status = UserStatus(regulationString = Regulation.CUSTOM.value)

        assertEquals("custom", EntitiesHelper.toMap(status)["regulation"])
    }

    private fun ids(enabled: String?, disabled: String?) = mapOf(
        "disabled" to listOfNotNull(disabled),
        "enabled" to listOfNotNull(enabled),
    )

    companion object {
        fun fullVendor() = Vendor(
            id = "vendor-1",
            name = "Vendor 1",
            namespaces = Vendor.Namespaces(iab2 = "12", num = 12, didomi = "vendor-1", sp = "sp-1"),
            policyUrl = "https://vendor.com/policy",
            purposeIds = listOf("cookies"),
            legIntPurposeIds = listOf("analytics"),
            featureIds = listOf("1"),
            flexiblePurposeIds = listOf("2"),
            specialFeatureIds = listOf("3"),
            specialPurposeIds = listOf("4"),
            urls = listOf(Vendor.Url(langId = "en", privacy = "https://vendor.com/en/privacy", legIntClaim = "https://vendor.com/en/li")),
            isIAB = true,
        )

        @Suppress("DEPRECATION")
        fun fullCurrentUserStatus() = CurrentUserStatus(
            purposes = mapOf("cookies" to CurrentUserStatus.PurposeStatus(id = "cookies", enabled = true)),
            vendors = mapOf("vendor-1" to CurrentUserStatus.VendorStatus(id = "vendor-1", enabled = false)),
            userId = "user-id",
            created = "2026-01-01T00:00:00.000Z",
            updated = "2026-01-02T00:00:00.000Z",
            consentString = "consent-string",
            additionalConsent = "1~",
            didomiDcs = "dcs",
            regulationString = "ccpa",
            gppString = "gpp",
        )

        fun fullUserStatus() = UserStatus(
            purposes = UserStatus.Purposes(
                global = UserStatus.Ids(enabled = setOf("cookies"), disabled = setOf("analytics")),
                consent = UserStatus.Ids(enabled = setOf("cookies"), disabled = setOf("analytics")),
                legitimateInterest = UserStatus.Ids(enabled = setOf("li_purpose")),
                essential = setOf("essential_purpose"),
            ),
            vendors = UserStatus.Vendors(
                global = UserStatus.Ids(enabled = setOf("vendor-1"), disabled = setOf("vendor-2")),
                globalConsent = UserStatus.Ids(enabled = setOf("vendor-1")),
                globalLegitimateInterest = UserStatus.Ids(disabled = setOf("vendor-2")),
                consent = UserStatus.Ids(enabled = setOf("vendor-1")),
                legitimateInterest = UserStatus.Ids(disabled = setOf("vendor-2")),
            ),
            userId = "user-id",
            created = "2026-01-01T00:00:00.000Z",
            updated = "2026-01-02T00:00:00.000Z",
            consentString = "consent-string",
            additionalConsent = "1~",
            didomiDcs = "dcs",
            regulationString = "gdpr",
        )
    }
}
