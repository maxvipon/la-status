import Foundation

/// Minimal LA state persisted for app + intents.
enum LAStatus: String, CaseIterable, Codable, Sendable {
    case active = "Live Activity"
    case none = "No LA"
}
