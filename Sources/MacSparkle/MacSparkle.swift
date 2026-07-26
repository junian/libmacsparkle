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

    public func setAppcastURL(_ urlString: String) -> Bool {
        guard let url = URL(string: urlString) else {
            return false
        }

        UserDefaults.standard.set(url.absoluteString, forKey: "SUFeedURL")
        self.controller = SPUStandardUpdaterController(startingUpdater: false, updaterDelegate: nil, userDriverDelegate: nil)
        self.updater = self.controller.updater

        return true
    }
}

@discardableResult
@MainActor
public func mac_sparkle_set_appcast_url(_ urlString: String) -> Bool {
    SparkleUpdater.shared.setAppcastURL(urlString)
}
