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

@_cdecl("mac_sparkle_set_eddsa_public_key")
public func mac_sparkle_set_eddsa_public_key(_ pubkey: UnsafePointer<CChar>?) -> Int32 {
    guard let pubkey else {
        return 0
    }

    let keyString = String(cString: pubkey)
    guard MacSparkleEdDSAValidation.isValidPublicKey(keyString) else {
        return 0
    }

    MacSparkleSettings.setEdDSAPublicKey(keyString)
    return 1
}
