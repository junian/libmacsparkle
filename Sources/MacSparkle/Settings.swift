import Foundation

enum MacSparkleSettings {
    private static let lock = NSLock()
    nonisolated(unsafe) private static var appcastURL: String?
    nonisolated(unsafe) private static var eddsaPublicKey: String?

    static func setAppcastURL(_ url: String) {
        lock.lock()
        defer { lock.unlock() }
        appcastURL = url
    }

    static func appcastURLString() -> String? {
        lock.lock()
        defer { lock.unlock() }
        return appcastURL
    }

    static func setEdDSAPublicKey(_ key: String) {
        lock.lock()
        defer { lock.unlock() }
        eddsaPublicKey = key
    }

    static func eddsaPublicKeyString() -> String? {
        lock.lock()
        defer { lock.unlock() }
        return eddsaPublicKey
    }
}

enum MacSparkleEdDSAValidation {
    static let publicKeyLength = 32

    static func isValidPublicKey(_ keyBase64: String) -> Bool {
        guard let data = Data(base64Encoded: keyBase64) else {
            return false
        }

        return data.count == publicKeyLength
    }
}

enum MacSparkleURLValidation {
    static func isSupportedAppcastURL(_ urlString: String) -> Bool {
        guard let url = URL(string: urlString),
              let scheme = url.scheme?.lowercased()
        else {
            return false
        }

        return scheme == "http" || scheme == "https"
    }
}
