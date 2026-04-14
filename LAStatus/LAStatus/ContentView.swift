import SwiftUI

struct ContentView: View {
    @State private var message: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    actionsSection
                    if let message {
                        errorCallout(message)
                    }
                    shortcutsHelpCard
                    footerNote
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .scrollIndicators(.hidden)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("LA Status")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var actionsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Live activity")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
                .tracking(0.6)
                .padding(.leading, 4)

            VStack(spacing: 12) {
                actionButton(
                    title: "Show Live Activity: Corp VPN"
                ) {
                    Task {
                        await apply(
                            .active,
                            liveActivityLabel: "Corp VPN",
                            dynamicIslandLabel: "Work"
                        )
                    }
                }

                actionButton(
                    title: "Show Live Activity: External VPN"
                ) {
                    Task {
                        await apply(
                            .active,
                            liveActivityLabel: "External VPN",
                            dynamicIslandLabel: "Ext"
                        )
                    }
                }

                Button(role: .destructive) {
                    Task { await apply(.none) }
                } label: {
                    Label {
                        Text("Hide Live Activity")
                    } icon: {
                        Image(systemName: "xmark.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 4)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
            }
        }
    }

    private func actionButton(
        title: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Label {
                Text(title)
            } icon: {
                StatusIcon(size: 22)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 4)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
    }

    private func errorCallout(_ text: String) -> some View {
        Label {
            Text(text)
                .font(.footnote)
                .foregroundStyle(.primary)
        } icon: {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.orange)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.orange.opacity(0.14))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(Color.orange.opacity(0.35), lineWidth: 0.5)
        }
        .accessibilityElement(children: .combine)
    }

    private var shortcutsHelpCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("How to use with Shortcuts")
                .font(.subheadline.weight(.semibold))
            Text("1. Add action `Show Live Activity`.\n2. Set `Live Activity Label` (normal length text).\n3. Set `Dynamic Island Label` (short text up to 8 chars).")
                .font(.footnote)
                .foregroundStyle(.secondary)
            Text("Use `Hide Live Activity` to stop the Live Activity.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        }
    }

    private var footerNote: some View {
        Text("Status here and in Shortcuts is manual only — it does not reflect the system connection.")
            .font(.footnote)
            .foregroundStyle(.tertiary)
            .multilineTextAlignment(.center)
            .padding(.top, 8)
            .padding(.horizontal, 8)
    }

    private func apply(
        _ newStatus: LAStatus,
        liveActivityLabel: String? = nil,
        dynamicIslandLabel: String? = nil
    ) async {
        message = nil
        do {
            if newStatus == .none {
                try await LALiveActivityManager.shared.stop()
            } else {
                try await LALiveActivityManager.shared.startOrUpdate(
                    status: newStatus,
                    liveActivityLabel: liveActivityLabel,
                    dynamicIslandLabel: dynamicIslandLabel
                )
            }
        } catch {
            message = error.localizedDescription
        }
    }
}

#Preview("Light") {
    ContentView()
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    ContentView()
        .preferredColorScheme(.dark)
}
