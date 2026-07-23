import Foundation

enum MacSparkleSettings {
    private static let lock = NSLock()
    nonisolated(unsafe) private static var appcastURL: String?

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
