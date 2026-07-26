import Foundation
import Sparkle

@MainActor
public final class SparkleUpdater {
    public static let shared = SparkleUpdater()

    public private(set) var controller: SPUStandardUpdaterController
    public private(set) var updater: SPUUpdater

    private init() {
        self.controller = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
        self.updater = self.controller.updater
    }

    public func checkForUpdates() {
        updater.checkForUpdates()
    }
}
