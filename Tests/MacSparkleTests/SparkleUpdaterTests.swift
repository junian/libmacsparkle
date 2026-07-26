import XCTest
@testable import MacSparkle

@MainActor
final class SparkleUpdaterTests: XCTestCase {
    func testSharedInstanceIsStable() {
        let first = SparkleUpdater.shared
        let second = SparkleUpdater.shared

        XCTAssertIdentical(first, second)
    }

    func testUpdaterIsAvailable() {
        let updater = SparkleUpdater.shared

        XCTAssertNotNil(updater.updater)
    }

    func testSettingAppcastURLUpdatesSparkleFeedURL() {
        let expectedURL = "https://example.com/appcast.xml"

        mac_sparkle_set_appcast_url(expectedURL)

        XCTAssertEqual(UserDefaults.standard.string(forKey: "SUFeedURL"), expectedURL)
        XCTAssertEqual(SparkleUpdater.shared.updater.feedURL?.absoluteString, expectedURL)
    }

    func testCABIEntryPointUpdatesSparkleFeedURL() {
        let expectedURL = "https://example.com/appcast-c.xml"
        let cString = (expectedURL as NSString).utf8String

        XCTAssertTrue(mac_sparkle_set_appcast_url_c(cString))
        XCTAssertEqual(UserDefaults.standard.string(forKey: "SUFeedURL"), expectedURL)
    }

    func testCABIEntryPointUpdatesEDDSAPublicKey() {
        let expectedKey = "test-public-key"
        let cString = (expectedKey as NSString).utf8String

        XCTAssertTrue(mac_sparkle_set_eddsa_public_key_c(cString))
        XCTAssertEqual(UserDefaults.standard.string(forKey: "SUPublicEDKey"), expectedKey)
    }

    func testCABIEntryPointUpdatesAppDetails() {
        let company = "Example Company"
        let app = "Example App"
        let version = "1.2.3"

        let companyCString = (company as NSString).utf8String
        let appCString = (app as NSString).utf8String
        let versionCString = (version as NSString).utf8String

        XCTAssertTrue(mac_sparkle_set_app_details_c(companyCString, appCString, versionCString))
        XCTAssertEqual(UserDefaults.standard.string(forKey: "SUBundleName"), "\(company) \(app) v\(version)")
    }

    func testCABIEntryPointInitializesUpdater() {
        XCTAssertTrue(mac_sparkle_init_c())
    }

    func testCABIEntryPointChecksForUpdatesWithUI() {
        XCTAssertTrue(mac_sparkle_check_update_with_ui_c())
    }
}
