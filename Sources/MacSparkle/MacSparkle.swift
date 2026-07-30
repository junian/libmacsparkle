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

/// set automatic check for updates. 1 == true, 0 == false
@MainActor
@_cdecl("mac_sparkle_set_automatic_check_for_updates")
public func mac_sparkle_set_automatic_check_for_updates(_ state: Int) {
    SparkleUpdater.shared.automaticallyChecksForUpdates = (state != 0)
}

/// get automatic check for updates state. 1 ==  true, 0 == false
@MainActor
@_cdecl("mac_sparkle_get_automatic_check_for_updates")
public func mac_sparkle_get_automatic_check_for_updates() -> Int {
    (SparkleUpdater.shared.automaticallyChecksForUpdates) ? 1 : 0
}

/// set update check interval
@MainActor
@_cdecl("mac_sparkle_set_update_check_interval")
public func mac_sparkle_set_update_check_interval(_ interval: Int) {
    SparkleUpdater.shared.updateCheckInterval = TimeInterval(interval)
}

/// get update check interval
@MainActor
@_cdecl("mac_sparkle_get_update_check_interval")
public func mac_sparkle_get_update_check_interval() -> Int {
    Int(SparkleUpdater.shared.updateCheckInterval)
}

/// get last update check time
@MainActor
@_cdecl("mac_sparkle_get_last_check_time")
public func mac_sparkle_get_last_check_time() -> time_t {
    guard let date = SparkleUpdater.shared.lastUpdateCheckDate else {
        return -1
    }

    return time_t(date.timeIntervalSince1970)
}
