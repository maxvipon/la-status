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
        TypeDisplayRepresentation(name: LocalizedStringResource("Color"))
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

private extension LAStatusColorChoice {
    var laStatusColor: LAStatusColor {
        switch self {
        case .accent: return .accent
        case .white: return .white
        case .black: return .black
        case .gray: return .gray
        case .red: return .red
        case .green: return .green
        case .blue: return .blue
        case .orange: return .orange
        case .purple: return .purple
        case .pink: return .pink
        }
    }
}

// MARK: - Actions

struct ShowLiveActivityIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Show Live Activity"
    static var description = IntentDescription("Sets the title and optional appearance for Live Activity and Dynamic Island.")

    static var openAppWhenRun: Bool = false

    @Parameter(title: "Title")
    var liveActivityTitle: String

    @Parameter(title: "Dynamic Island Label")
    var dynamicIslandLabel: String?

    @Parameter(title: "Dynamic Island Icon (SF Symbol)", default: "network")
    var dynamicIslandIcon: String

    @Parameter(title: "Color", default: .white)
    var elementsColor: LAStatusColorChoice

    static var parameterSummary: some ParameterSummary {
        Summary("Show Live Activity with \(\.$liveActivityTitle)") {
            \.$dynamicIslandIcon
            \.$dynamicIslandLabel
            \.$elementsColor
        }
    }

    init() {
        self.liveActivityTitle = String(localized: "Live Activity Title")
        self.dynamicIslandLabel = nil
        self.dynamicIslandIcon = "network"
        self.elementsColor = .white
    }

    func perform() async throws -> some IntentResult {
        try await Task { @MainActor in
            try await LALiveActivityManager.shared.startOrUpdate(
                status: .active,
                liveActivityTitle: liveActivityTitle,
                dynamicIslandLabel: dynamicIslandLabel,
                dynamicIslandIcon: dynamicIslandIcon,
                elementsColor: elementsColor.laStatusColor
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
            shortTitle: LocalizedStringResource("Show Live Activity"),
            systemImageName: "bolt.horizontal.circle"
        )
        AppShortcut(
            intent: HideLiveActivityIntent(),
            phrases: [
                "Hide Live Activity in \(.applicationName)",
                "Stop Live Activity in \(.applicationName)"
            ],
            shortTitle: LocalizedStringResource("Hide Live Activity"),
            systemImageName: "xmark.circle"
        )
    }
}
