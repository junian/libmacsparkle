import AppKit
import Foundation
import Sparkle

/// Manages the shared Sparkle updater state for the library.
@MainActor
public final class SparkleUpdater: NSObject, SPUUpdaterDelegate {
    /// The singleton instance used by the library.
    public static let shared = SparkleUpdater()

    /// The underlying updater controller instance.
    private var controller: SPUStandardUpdaterController?
    private var appCastURL: String?

    /// Get or set automatically Checks For Updates
    public var automaticallyChecksForUpdates: Bool {
        get {
            controller?.updater.automaticallyChecksForUpdates ?? false
        }
        set {
            controller?.updater.automaticallyChecksForUpdates = newValue
        }
    }
    
    /// Creates the shared updater controller and stores the initial updater reference.
    private override init() {
        super.init()
        
        self.controller = SPUStandardUpdaterController(
            startingUpdater: false,
            updaterDelegate: self,
            userDriverDelegate: nil
        )
        self.appCastURL = nil
    }
    
    public func setAppcastURL(_ url: String) {
        self.appCastURL = url
    }

    public func initialize() {
         controller?.startUpdater()
    }

    /// Triggers Sparkle to check for updates.
    public func checkForUpdates() {
        controller?.checkForUpdates(nil)
    }
    
    public func feedURLString(for updater: SPUUpdater) -> String? {
        return appCastURL;
    }
}
