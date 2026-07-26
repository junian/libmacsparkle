import AppKit
import Foundation
import Sparkle

/// Manages the shared Sparkle updater state for the library.
@MainActor
public final class SparkleUpdater: NSObject {
    /// The singleton instance used by the library.
    public static let shared = SparkleUpdater()

    /// The underlying updater controller instance.
    public private(set) var controller: SPUStandardUpdaterController

    /// Creates the shared updater controller and stores the initial updater reference.
    private override init() {
        self.controller = SPUStandardUpdaterController(
            startingUpdater: false,
            updaterDelegate: nil,
            userDriverDelegate: nil
        )
    }

    public func initialize() {
         controller.startUpdater()
        
    }

    /// Triggers Sparkle to check for updates.
    public func checkForUpdates() {
        controller.checkForUpdates(nil)
    }
}
