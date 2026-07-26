import Foundation
import Sparkle

/// Sets the appcast URL for Sparkle from a C string passed by a native caller.
@discardableResult
@MainActor
@_cdecl("mac_sparkle_set_appcast_url")
public func mac_sparkle_set_appcast_url(_ urlString: UnsafePointer<CChar>?) -> Bool {
    guard let urlString else {
        return false
    }

    let value = String(cString: urlString)
    return SparkleUpdater.shared.setAppcastURL(value)
}

/// Stores the EDDSA public key used by Sparkle in UserDefaults.
@discardableResult
@MainActor
@_cdecl("mac_sparkle_set_eddsa_public_key")
public func mac_sparkle_set_eddsa_public_key(_ publicKey: UnsafePointer<CChar>?) -> Bool {
    guard let publicKey else {
        return false
    }

    let value = String(cString: publicKey)
    return SparkleUpdater.shared.setEDDSAPublicKey(value)
}

/// Stores the app details as a combined bundle name string for Sparkle.
@discardableResult
@MainActor
@_cdecl("mac_sparkle_set_app_details")
public func mac_sparkle_set_app_details(_ companyName: UnsafePointer<CChar>?, _ appName: UnsafePointer<CChar>?, _ versionString: UnsafePointer<CChar>?) -> Bool {
    guard let companyName, let appName, let versionString else {
        return false
    }

    let company = String(cString: companyName)
    let app = String(cString: appName)
    let version = String(cString: versionString)
    return SparkleUpdater.shared.setAppDetails(companyName: company, appName: app, versionString: version)
}

/// Initializes the Sparkle updater so it can be used on first launch.
@discardableResult
@MainActor
@_cdecl("mac_sparkle_init")
public func mac_sparkle_init() -> Bool {
    SparkleUpdater.shared.initialize()
    return true
}

/// Invokes the manual update-check flow exposed by Sparkle.
@discardableResult
@MainActor
@_cdecl("mac_sparkle_check_update_with_ui")
public func mac_sparkle_check_update_with_ui() -> Bool {
    SparkleUpdater.shared.checkForUpdates()
    return true
}

/// Cleans up the updater state before the application exits.
@discardableResult
@MainActor
@_cdecl("mac_sparkle_cleanup")
public func mac_sparkle_cleanup() -> Bool {
    SparkleUpdater.shared.cleanup()
    return true
}
