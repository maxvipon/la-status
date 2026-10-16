import Foundation

/// Persists the last manually selected LA status for the main app and intents.
enum LAStatusStorage {
    private static var suite: UserDefaults {
        guard let identifier = Bundle.main.object(forInfoDictionaryKey: "LAAppGroupIdentifier") as? String,
              !identifier.isEmpty,
              !identifier.contains("$(") else {
            fatalError("Missing or unresolved LAAppGroupIdentifier in this product's Info.plist. Set APP_GROUP_IDENTIFIER in the Xcode configuration.")
        }

        guard let suite = UserDefaults(suiteName: identifier) else {
            fatalError("Unable to open the App Group UserDefaults suite '\(identifier)'. Check the App Groups capability and APP_GROUP_IDENTIFIER setting.")
        }

        return suite
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
