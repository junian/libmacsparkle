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

    private let defaultAutomaticallyChecksForUpdates = false
    /// Get or set automatically Checks For Updates
    public var automaticallyChecksForUpdates: Bool {
        get {
            controller?.updater.automaticallyChecksForUpdates ?? defaultAutomaticallyChecksForUpdates
        }
        set {
            controller?.updater.automaticallyChecksForUpdates = newValue
        }
    }
    
    private let defaultScheduledCheckInterval = TimeInterval(86_400)
    /// Get or set update check interval
    public var updateCheckInterval: TimeInterval {
        get {
            controller?.updater.updateCheckInterval ?? defaultScheduledCheckInterval
        }
        set {
            controller?.updater.updateCheckInterval = newValue
        }
    }
    
    public var lastUpdateCheckDate: Date? {
        get {
            controller?.updater.lastUpdateCheckDate
        }
    }
    
    /// The HTTP headers used when checking for updates, downloading release
    /// notes, and downloading updates.
    public var httpHeaders: [String: String]? {
        get {
            controller?.updater.httpHeaders
        }
        set {
            controller?.updater.httpHeaders = newValue
        }
    }
    
    /// Sets an HTTP header to be sent with update requests, adding or replacing
    /// the header with the given name.
    public func setHTTPHeader(_ name: String, value: String) {
        var headers = controller?.updater.httpHeaders ?? [:]
        headers[name] = value
        controller?.updater.httpHeaders = headers
    }
    
    /// Removes all HTTP headers previously set on the updater.
    public func clearHTTPHeaders() {
        controller?.updater.httpHeaders = nil
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

    /// Triggers Sparkle to check for updates in the background without UI.
    /// Use with caution and generally not recommended: Sparkle schedules
    /// background checks automatically by default, and calling this manually
    /// may interfere with Sparkle's scheduler.
    public func checkForUpdatesInBackground() {
        controller?.updater.checkForUpdatesInBackground()
    }
    
    public func feedURLString(for updater: SPUUpdater) -> String? {
        return appCastURL;
    }
}
