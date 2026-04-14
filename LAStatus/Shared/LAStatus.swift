import Foundation

/// Manually selected LA mode (not tied to system state).
enum LAStatus: String, CaseIterable, Codable, Sendable {
    case work = "Work LA"
    case external = "External LA"
    case none = "No LA"

    var displayTitle: String { rawValue }

    var shortLabel: String {
        switch self {
        case .work: return "Work"
        case .external: return "Ext"
        case .none: return "Off"
        }
    }
}
