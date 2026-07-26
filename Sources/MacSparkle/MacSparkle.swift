import Foundation
import Sparkle

/// Sets the appcast URL for Sparkle using the Swift API.
@discardableResult
@MainActor
public func mac_sparkle_set_appcast_url(_ urlString: String) -> Bool {
    SparkleUpdater.shared.setAppcastURL(urlString)
}

/// Sets the appcast URL for Sparkle from a C string passed by a native caller.
@discardableResult
@MainActor
@_cdecl("mac_sparkle_set_appcast_url")
public func mac_sparkle_set_appcast_url_c(_ urlString: UnsafePointer<CChar>?) -> Bool {
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
public func mac_sparkle_set_eddsa_public_key_c(_ publicKey: UnsafePointer<CChar>?) -> Bool {
    guard let publicKey else {
        return false
    }

    let value = String(cString: publicKey)
    UserDefaults.standard.set(value, forKey: "SUPublicEDKey")
    return true
}

/// Stores the app details as a combined bundle name string for Sparkle.
@discardableResult
@MainActor
@_cdecl("mac_sparkle_set_app_details")
public func mac_sparkle_set_app_details_c(_ companyName: UnsafePointer<CChar>?, _ appName: UnsafePointer<CChar>?, _ versionString: UnsafePointer<CChar>?) -> Bool {
    guard let companyName, let appName, let versionString else {
        return false
    }

    let company = String(cString: companyName)
    let app = String(cString: appName)
    let version = String(cString: versionString)
    let bundleName = "\(company) \(app) v\(version)"

    UserDefaults.standard.set(bundleName, forKey: "SUBundleName")
    return true
}

/// Initializes the Sparkle updater so it can be used on first launch.
@discardableResult
@MainActor
@_cdecl("mac_sparkle_init")
public func mac_sparkle_init_c() -> Bool {
    SparkleUpdater.shared.checkForUpdates()
    return true
}

/// Invokes the manual update-check flow exposed by Sparkle.
@discardableResult
@MainActor
@_cdecl("mac_sparkle_check_update_with_ui")
public func mac_sparkle_check_update_with_ui_c() -> Bool {
    SparkleUpdater.shared.checkForUpdates()
    return true
}

/// Cleans up the updater state before the application exits.
@discardableResult
@MainActor
@_cdecl("mac_sparkle_cleanup")
public func mac_sparkle_cleanup_c() -> Bool {
    SparkleUpdater.shared.cleanup()
    return true
}
