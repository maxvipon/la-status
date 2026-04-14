import ActivityKit
import Foundation

/// Starts, updates, or ends the LA Live Activity. Does not read system state.
@MainActor
final class LALiveActivityManager {
    static let shared = LALiveActivityManager()

    private init() {}

    func startOrUpdate(
        status: LAStatus,
        liveActivityLabel: String? = nil,
        dynamicIslandLabel: String? = nil
    ) async throws {
        guard status != .none else {
            try await stop()
            return
        }

        LAStatusStorage.save(status)
        let trimmedLiveLabel = liveActivityLabel?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let normalizedLiveLabel = trimmedLiveLabel.isEmpty ? status.displayTitle : trimmedLiveLabel
        let trimmedIslandLabel = dynamicIslandLabel?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let normalizedIslandLabel = trimmedIslandLabel.isEmpty
            ? String(normalizedLiveLabel.prefix(8))
            : String(trimmedIslandLabel.prefix(8))

        let state = LAActivityAttributes.ContentState(
            liveActivityLabel: normalizedLiveLabel,
            dynamicIslandLabel: normalizedIslandLabel
        )
        let content = ActivityContent(state: state, staleDate: nil)

        if let activity = Activity<LAActivityAttributes>.activities.first {
            await activity.update(content)
            return
        }

        _ = try Activity.request(
            attributes: LAActivityAttributes(),
            content: content,
            pushType: nil
        )
    }

    func stop() async throws {
        LAStatusStorage.save(.none)

        for activity in Activity<LAActivityAttributes>.activities {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
    }
}
