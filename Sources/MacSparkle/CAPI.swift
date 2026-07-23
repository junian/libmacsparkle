import Foundation

@_cdecl("mac_sparkle_set_appcast_url")
public func mac_sparkle_set_appcast_url(_ url: UnsafePointer<CChar>?) {
    guard let url else {
        return
    }

    let urlString = String(cString: url)
    guard MacSparkleURLValidation.isSupportedAppcastURL(urlString) else {
        return
    }

    MacSparkleSettings.setAppcastURL(urlString)
}
