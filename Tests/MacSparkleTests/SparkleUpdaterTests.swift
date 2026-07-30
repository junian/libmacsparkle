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

    func testCABIEntryPointSetsAppcastURL() {
        XCTAssertNoThrow(mac_sparkle_set_appcast_url("https://example.com/appcast.xml"))
    }

    func testCABIEntryPointSetsAutomaticCheckForUpdates() {
        XCTAssertNoThrow(mac_sparkle_set_automatic_check_for_updates(1))
        XCTAssertEqual(mac_sparkle_get_automatic_check_for_updates(), 1)
        
        XCTAssertNoThrow(mac_sparkle_set_automatic_check_for_updates(0))
        XCTAssertEqual(mac_sparkle_get_automatic_check_for_updates(), 0)
    }

    func testCABIEntryPointSetsUpdateCheckInterval() {
        XCTAssertNoThrow(mac_sparkle_set_update_check_interval(3600))
        XCTAssertEqual(mac_sparkle_get_update_check_interval(), 3600)
    }

    func testCABIEntryPointGetsLastCheckTime() {
        let lastCheckTime = mac_sparkle_get_last_check_time()
        // Should return -1 if never checked, or a valid timestamp
        XCTAssertTrue(lastCheckTime == -1 || lastCheckTime > 0)
    }

    func testSparkleUpdaterSetAppcastURL() {
        let updater = SparkleUpdater.shared
        XCTAssertNoThrow(updater.setAppcastURL("https://example.com/appcast.xml"))
    }

    func testSparkleUpdaterInitialize() {
        let updater = SparkleUpdater.shared
        XCTAssertNoThrow(updater.initialize())
    }

    func testSparkleUpdaterCheckForUpdates() {
        let updater = SparkleUpdater.shared
        XCTAssertNoThrow(updater.checkForUpdates())
    }

    func testSparkleUpdaterAutomaticallyChecksForUpdates() {
        let updater = SparkleUpdater.shared
        
        // Test setting to true
        updater.automaticallyChecksForUpdates = true
        XCTAssertTrue(updater.automaticallyChecksForUpdates)
        
        // Test setting to false
        updater.automaticallyChecksForUpdates = false
        XCTAssertFalse(updater.automaticallyChecksForUpdates)
    }

    func testSparkleUpdaterUpdateCheckInterval() {
        let updater = SparkleUpdater.shared
        
        // Test setting interval
        updater.updateCheckInterval = 7200
        XCTAssertEqual(updater.updateCheckInterval, 7200)
        
        // Test another interval
        updater.updateCheckInterval = 86400
        XCTAssertEqual(updater.updateCheckInterval, 86400)
    }

    func testSparkleUpdaterLastUpdateCheckDate() {
        let updater = SparkleUpdater.shared
        // This should be nil if never checked, or a valid date
        let lastCheckDate = updater.lastUpdateCheckDate
        XCTAssertTrue(lastCheckDate == nil || lastCheckDate! <= Date())
    }

    func testCABIWithNullURL() {
        // Should handle null URL gracefully
        XCTAssertNoThrow(mac_sparkle_set_appcast_url(nil))
    }

    func testCABIAutomaticCheckForUpdatesEdgeCases() {
        // Test with various integer values
        XCTAssertNoThrow(mac_sparkle_set_automatic_check_for_updates(1))
        XCTAssertEqual(mac_sparkle_get_automatic_check_for_updates(), 1)
        
        XCTAssertNoThrow(mac_sparkle_set_automatic_check_for_updates(0))
        XCTAssertEqual(mac_sparkle_get_automatic_check_for_updates(), 0)
        
        // Test with non-zero values that should be treated as true
        XCTAssertNoThrow(mac_sparkle_set_automatic_check_for_updates(5))
        XCTAssertEqual(mac_sparkle_get_automatic_check_for_updates(), 1)
        
        XCTAssertNoThrow(mac_sparkle_set_automatic_check_for_updates(-1))
        XCTAssertEqual(mac_sparkle_get_automatic_check_for_updates(), 1)
    }

    func testCABIUpdateCheckIntervalEdgeCases() {
        // Test with various intervals
        XCTAssertNoThrow(mac_sparkle_set_update_check_interval(0))
        XCTAssertEqual(mac_sparkle_get_update_check_interval(), 0)
        
        XCTAssertNoThrow(mac_sparkle_set_update_check_interval(3600))
        XCTAssertEqual(mac_sparkle_get_update_check_interval(), 3600)
        
        // Test with large interval
        XCTAssertNoThrow(mac_sparkle_set_update_check_interval(604800)) // 1 week
        XCTAssertEqual(mac_sparkle_get_update_check_interval(), 604800)
    }

}
