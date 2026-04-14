import Foundation

/// Persists the last manually selected LA status for the main app and intents.
enum LAStatusStorage {
    private static var suite: UserDefaults {
        UserDefaults(suiteName: AppGroup.id) ?? .standard
    }

    private static let key = "lastLAStatus"

    static func load() -> LAStatus {
        guard let raw = suite.string(forKey: key),
              let status = LAStatus(rawValue: raw) else {
            return .none
        }
        return status
    }

    static func save(_ status: LAStatus) {
        suite.set(status.rawValue, forKey: key)
    }
}

enum AppGroup {
    static let id = "group.com.lastatus.shared"
}
