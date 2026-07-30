import XCTest
@testable import MacSparkle

@MainActor
final class SparkleUpdaterTests: XCTestCase {
    func testSharedInstanceIsStable() {
        let first = SparkleUpdater.shared
        let second = SparkleUpdater.shared

        XCTAssertIdentical(first, second)
    }

    func testCABIEntryPointInitializesUpdater() {
        XCTAssertNoThrow(mac_sparkle_init())
    }

    func testCABIEntryPointChecksForUpdatesWithUI() {
        XCTAssertNoThrow(mac_sparkle_check_update_with_ui())
    }

}
