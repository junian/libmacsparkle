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
