import Foundation
import Sparkle

/// Sets the appcast URL for Sparkle from a C string passed by a native caller.
@MainActor
@_cdecl("mac_sparkle_set_appcast_url")
public func mac_sparkle_set_appcast_url(_ urlString: UnsafePointer<CChar>?) {
    guard let urlString else {
        return
    }

    let value = String(cString: urlString)
    SparkleUpdater.shared.setAppcastURL(value)
}

/// Initializes the Sparkle updater so it can be used on first launch.
@MainActor
@_cdecl("mac_sparkle_init")
public func mac_sparkle_init() {
    SparkleUpdater.shared.initialize()
}

/// Invokes the manual update-check flow exposed by Sparkle.
@MainActor
@_cdecl("mac_sparkle_check_update_with_ui")
public func mac_sparkle_check_update_with_ui() {
    SparkleUpdater.shared.checkForUpdates()
}
