import AppIntents
import Foundation

// MARK: - Actions

struct ShowLiveActivityIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Show Live Activity"
    static var description = IntentDescription("Sets custom labels for Live Activity and Dynamic Island.")

    static var openAppWhenRun: Bool = false

    @Parameter(title: "Live Activity Label")
    var liveActivityLabel: String

    @Parameter(title: "Dynamic Island Label")
    var dynamicIslandLabel: String

    init() {
        self.liveActivityLabel = "Work LA"
        self.dynamicIslandLabel = "Work"
    }

    func perform() async throws -> some IntentResult {
        try await Task { @MainActor in
            try await LALiveActivityManager.shared.startOrUpdate(
                status: .work,
                liveActivityLabel: liveActivityLabel,
                dynamicIslandLabel: dynamicIslandLabel
            )
        }.value
        return .result()
    }
}

struct HideLiveActivityIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Hide Live Activity"
    static var description = IntentDescription("Stops the Live Activity.")

    static var openAppWhenRun: Bool = false

    func perform() async throws -> some IntentResult {
        try await Task { @MainActor in
            try await LALiveActivityManager.shared.stop()
        }.value
        return .result()
    }
}

// MARK: - App Shortcuts (discoverability in Shortcuts app)

struct LAStatusShortcuts: AppShortcutsProvider {
    @AppShortcutsBuilder
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: ShowLiveActivityIntent(),
            phrases: [
                "Show Live Activity in \(.applicationName)"
            ],
            shortTitle: "Show Live Activity",
            systemImageName: "network"
        )
        AppShortcut(
            intent: HideLiveActivityIntent(),
            phrases: [
                "Hide Live Activity in \(.applicationName)",
                "Stop Live Activity in \(.applicationName)"
            ],
            shortTitle: "Hide Live Activity",
            systemImageName: "xmark.circle"
        )
    }
}
