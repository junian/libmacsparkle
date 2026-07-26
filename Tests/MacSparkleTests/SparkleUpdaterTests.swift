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
}
