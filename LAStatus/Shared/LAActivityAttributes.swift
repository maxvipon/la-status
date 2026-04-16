import ActivityKit
import Foundation

enum LAStatusColor: String, Codable, Hashable, Sendable {
    case accent
    case white
    case black
    case gray
    case red
    case green
    case blue
    case orange
    case purple
    case pink
}

struct LAActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable, Sendable {
        var liveActivityLabel: String
        var dynamicIslandLabel: String
        var iconTextColor: LAStatusColor
    }
}
