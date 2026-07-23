import Testing
@testable import MacSparkle

@Test func setAppcastURLStoresValidHTTPSURL() {
    MacSparkleSettings.setAppcastURL("https://example.com/appcast.xml")
    #expect(MacSparkleSettings.appcastURLString() == "https://example.com/appcast.xml")
}

@Test func setAppcastURLStoresValidHTTPURL() {
    MacSparkleSettings.setAppcastURL("http://example.com/appcast.xml")
    #expect(MacSparkleSettings.appcastURLString() == "http://example.com/appcast.xml")
}

@Test func supportedAppcastURLAcceptsHTTPAndHTTPS() {
    #expect(MacSparkleURLValidation.isSupportedAppcastURL("https://example.com/appcast.xml"))
    #expect(MacSparkleURLValidation.isSupportedAppcastURL("http://example.com/appcast.xml"))
}

@Test func supportedAppcastURLRejectsOtherSchemes() {
    #expect(!MacSparkleURLValidation.isSupportedAppcastURL("ftp://example.com/appcast.xml"))
    #expect(!MacSparkleURLValidation.isSupportedAppcastURL("file:///tmp/appcast.xml"))
    #expect(!MacSparkleURLValidation.isSupportedAppcastURL("not-a-url"))
}

@Test func cAPIStoresValidURL() {
    "https://example.com/feed.xml".withCString { pointer in
        mac_sparkle_set_appcast_url(pointer)
    }
    #expect(MacSparkleSettings.appcastURLString() == "https://example.com/feed.xml")
}

@Test func cAPIIgnoresInvalidURL() {
    MacSparkleSettings.setAppcastURL("https://example.com/feed.xml")

    "ftp://example.com/feed.xml".withCString { pointer in
        mac_sparkle_set_appcast_url(pointer)
    }

    #expect(MacSparkleSettings.appcastURLString() == "https://example.com/feed.xml")
}

@Test func cAPIIgnoresNullPointer() {
    MacSparkleSettings.setAppcastURL("https://example.com/feed.xml")
    mac_sparkle_set_appcast_url(nil)
    #expect(MacSparkleSettings.appcastURLString() == "https://example.com/feed.xml")
}

@Test func eddsaValidationAcceptsValidPublicKey() {
    #expect(MacSparkleEdDSAValidation.isValidPublicKey("pfIShU4dEXqPd5ObYNfDBiQWcXozk7estwzTnF9BamQ="))
}

@Test func eddsaValidationRejectsInvalidBase64() {
    #expect(!MacSparkleEdDSAValidation.isValidPublicKey("not-valid-base64!!!"))
}

@Test func eddsaValidationRejectsWrongKeySize() {
    #expect(!MacSparkleEdDSAValidation.isValidPublicKey("AQID"))
}

@Test func cAPIStoresValidEdDSAPublicKey() {
    let publicKey = "pfIShU4dEXqPd5ObYNfDBiQWcXozk7estwzTnF9BamQ="
    let result = publicKey.withCString { pointer in
        mac_sparkle_set_eddsa_public_key(pointer)
    }
    #expect(result == 1)
    #expect(MacSparkleSettings.eddsaPublicKeyString() == publicKey)
}

@Test func cAPIRejectsInvalidEdDSAPublicKey() {
    MacSparkleSettings.setEdDSAPublicKey("pfIShU4dEXqPd5ObYNfDBiQWcXozk7estwzTnF9BamQ=")

    let result = "invalid-key".withCString { pointer in
        mac_sparkle_set_eddsa_public_key(pointer)
    }

    #expect(result == 0)
    #expect(MacSparkleSettings.eddsaPublicKeyString() == "pfIShU4dEXqPd5ObYNfDBiQWcXozk7estwzTnF9BamQ=")
}

@Test func cAPIRejectsNullEdDSAPublicKey() {
    #expect(mac_sparkle_set_eddsa_public_key(nil) == 0)
}

@Test func setAppDetailsStoresAllFields() {
    MacSparkleSettings.setAppDetails(
        companyName: "Acme Inc",
        appName: "My App",
        appVersion: "1.2.3"
    )
    #expect(MacSparkleSettings.companyNameString() == "Acme Inc")
    #expect(MacSparkleSettings.appNameString() == "My App")
    #expect(MacSparkleSettings.appVersionString() == "1.2.3")
}

@Test func setAppDetailsSkipsNilFields() {
    MacSparkleSettings.setAppDetails(
        companyName: "Acme Inc",
        appName: "My App",
        appVersion: "1.0"
    )

    MacSparkleSettings.setAppDetails(
        companyName: nil,
        appName: "Renamed App",
        appVersion: nil
    )

    #expect(MacSparkleSettings.companyNameString() == "Acme Inc")
    #expect(MacSparkleSettings.appNameString() == "Renamed App")
    #expect(MacSparkleSettings.appVersionString() == "1.0")
}

@Test func cAPIStoresAppDetails() {
    ("Acme Inc").withCString { companyName in
        ("My App").withCString { appName in
            ("1.2rc1").withCString { appVersion in
                mac_sparkle_set_app_details(companyName, appName, appVersion)
            }
        }
    }

    #expect(MacSparkleSettings.companyNameString() == "Acme Inc")
    #expect(MacSparkleSettings.appNameString() == "My App")
    #expect(MacSparkleSettings.appVersionString() == "1.2rc1")
}

private func withWideCString<T>(_ string: String, _ body: (UnsafePointer<Int32>) throws -> T) rethrows -> T {
    let buffer = Array(string.unicodeScalars.map { Int32($0.value) } + [0])
    return try buffer.withUnsafeBufferPointer { ptr in
        try body(ptr.baseAddress!)
    }
}
