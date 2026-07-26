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
}
