import ActivityKit
import Foundation

struct LAActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable, Sendable {
        var liveActivityLabel: String
        var dynamicIslandLabel: String
    }
}
