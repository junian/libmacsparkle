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
