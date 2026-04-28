import ActivityKit
import Foundation
import UIKit

/// Starts, updates, or ends the LA Live Activity. Does not read system state.
@MainActor
final class LALiveActivityManager {
    static let shared = LALiveActivityManager()

    private init() {}

    func startOrUpdate(
        status: LAStatus,
        liveActivityLabel: String? = nil,
        dynamicIslandLabel: String? = nil,
        iconSymbolName: String? = nil,
        iconTextColor: LAStatusColor = .white
    ) async throws {
        guard status != .none else {
            try await stop()
            return
        }

        LAStatusStorage.save(status)
        let trimmedLiveLabel = liveActivityLabel?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let normalizedLiveLabel = trimmedLiveLabel.isEmpty ? LAStatus.active.rawValue : trimmedLiveLabel
        let trimmedIslandLabel = dynamicIslandLabel?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let normalizedIslandLabel = trimmedIslandLabel.isEmpty
            ? String(normalizedLiveLabel.prefix(8))
            : String(trimmedIslandLabel.prefix(8))
        let trimmedSymbolName = iconSymbolName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let normalizedSymbolName = Self.normalizedSymbolName(from: trimmedSymbolName)

        let state = LAActivityAttributes.ContentState(
            liveActivityLabel: normalizedLiveLabel,
            dynamicIslandLabel: normalizedIslandLabel,
            iconSymbolName: normalizedSymbolName,
            iconTextColor: iconTextColor
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

    private static func normalizedSymbolName(from rawValue: String) -> String {
        guard !rawValue.isEmpty else { return "network" }
        return UIImage(systemName: rawValue) == nil ? "network" : rawValue
    }
}
