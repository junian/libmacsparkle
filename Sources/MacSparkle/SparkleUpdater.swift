import Foundation
import Sparkle

/// Manages the shared Sparkle updater state for the library.
@MainActor
public final class SparkleUpdater {
    /// The singleton instance used by the library.
    public static let shared = SparkleUpdater()

    /// The underlying updater controller instance.
    public private(set) var controller: SPUStandardUpdaterController

    /// The updater instance exposed for Sparkle interactions.
    public private(set) var updater: SPUUpdater

    /// Creates the shared updater controller and stores the initial updater reference.
    private init() {
        self.controller = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
        self.updater = self.controller.updater
    }

    /// Triggers Sparkle to check for updates.
    public func checkForUpdates() {
        updater.checkForUpdates()
    }

    /// Updates the appcast URL used by Sparkle and refreshes the updater state.
    public func setAppcastURL(_ urlString: String) -> Bool {
        guard let url = URL(string: urlString) else {
            return false
        }

        UserDefaults.standard.set(url.absoluteString, forKey: "SUFeedURL")
        resetUpdater()

        return true
    }

    /// Resets the updater state during shutdown or cleanup.
    public func cleanup() {
        resetUpdater()
    }

    /// Recreates the updater controller and updater references.
    private func resetUpdater() {
        self.controller = SPUStandardUpdaterController(startingUpdater: false, updaterDelegate: nil, userDriverDelegate: nil)
        self.updater = self.controller.updater
    }
}
