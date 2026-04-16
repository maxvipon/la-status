import AppIntents
import Foundation

enum LAStatusColorChoice: String, AppEnum, Codable, Hashable, Sendable {
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

    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(name: LocalizedStringResource("Icon & Text Color"))
    }

    static let caseDisplayRepresentations: [LAStatusColorChoice: DisplayRepresentation] = [
        .accent: DisplayRepresentation(
            title: LocalizedStringResource("Accent")
        ),
        .white: DisplayRepresentation(
            title: LocalizedStringResource("White")
        ),
        .black: DisplayRepresentation(
            title: LocalizedStringResource("Black")
        ),
        .gray: DisplayRepresentation(
            title: LocalizedStringResource("Gray")
        ),
        .red: DisplayRepresentation(
            title: LocalizedStringResource("Red")
        ),
        .green: DisplayRepresentation(
            title: LocalizedStringResource("Green")
        ),
        .blue: DisplayRepresentation(
            title: LocalizedStringResource("Blue")
        ),
        .orange: DisplayRepresentation(
            title: LocalizedStringResource("Orange")
        ),
        .purple: DisplayRepresentation(
            title: LocalizedStringResource("Purple")
        ),
        .pink: DisplayRepresentation(
            title: LocalizedStringResource("Pink")
        )
    ]
}

// MARK: - Actions

struct ShowLiveActivityIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Show Live Activity"
    static var description = IntentDescription("Sets labels and styling colors for Live Activity and Dynamic Island.")

    static var openAppWhenRun: Bool = false

    @Parameter(title: "Live Activity Label")
    var liveActivityLabel: String

    @Parameter(title: "Dynamic Island Label")
    var dynamicIslandLabel: String

    @Parameter(title: "Icon & Text Color", default: .white)
    var iconTextColor: LAStatusColorChoice

    init() {
        self.liveActivityLabel = "Live Activity Text"
        self.dynamicIslandLabel = "LA"
        self.iconTextColor = .white
    }

    func perform() async throws -> some IntentResult {
        try await Task { @MainActor in
            try await LALiveActivityManager.shared.startOrUpdate(
                status: .active,
                liveActivityLabel: liveActivityLabel,
                dynamicIslandLabel: dynamicIslandLabel,
                iconTextColor: LAStatusColor(rawValue: iconTextColor.rawValue) ?? .white
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
