import Foundation
import Sparkle

/// Initializes the Sparkle updater so it can be used on first launch.
@MainActor
@_cdecl("mac_sparkle_init")
public func mac_sparkle_init() {
    SparkleUpdater.shared.initialize()
}

/// Invokes the manual update-check flow exposed by Sparkle.
@discardableResult
@MainActor
@_cdecl("mac_sparkle_check_update_with_ui")
public func mac_sparkle_check_update_with_ui() -> Bool {
    SparkleUpdater.shared.checkForUpdates()
    return true
}
