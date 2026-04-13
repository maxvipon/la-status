import SwiftUI

struct ContentView: View {
    @State private var status: VPNStatus = VPNStatusStorage.load()
    @State private var message: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    statusCard
                    actionsSection
                    if let message {
                        errorCallout(message)
                    }
                    footerNote
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .scrollIndicators(.hidden)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("VPN Status")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear { refresh() }
    }

    private var statusCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Saved status", systemImage: "checkmark.shield.fill")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)

            HStack(alignment: .center, spacing: 10) {
                Group {
                    if status == .work {
                        WorkVPNIcon(size: 32)
                    } else {
                        Image(systemName: iconName(for: status))
                            .font(.system(size: 28, weight: .medium))
                            .foregroundStyle(.tint)
                            .symbolRenderingMode(.hierarchical)
                    }
                }
                .accessibilityHidden(true)

                Text(status.displayTitle)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.primary)
                    .accessibilityAddTraits(.isHeader)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(Color(.separator).opacity(0.45), lineWidth: 0.5)
        }
    }

    private var actionsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Live Activity")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
                .tracking(0.6)
                .padding(.leading, 4)

            VStack(spacing: 12) {
                actionButton(
                    title: "Show Work VPN",
                    subtitle: "Lock Screen & Dynamic Island",
                    workVPNAsset: true
                ) {
                    Task { await apply(.work) }
                }

                actionButton(
                    title: "Show External VPN",
                    subtitle: "Lock Screen & Dynamic Island",
                    workVPNAsset: false,
                    systemImage: "network.badge.shield.half.filled"
                ) {
                    Task { await apply(.external) }
                }

                Button(role: .destructive) {
                    Task { await apply(.none) }
                } label: {
                    Label {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Clear VPN")
                            Text("Stop Live Activity")
                                .font(.caption.weight(.medium))
                                .foregroundStyle(.secondary)
                        }
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
        subtitle: String,
        workVPNAsset: Bool,
        systemImage: String = "network",
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Label {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                    Text(subtitle)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.secondary)
                }
            } icon: {
                if workVPNAsset {
                    WorkVPNIcon(size: 22)
                } else {
                    Image(systemName: systemImage)
                        .symbolRenderingMode(.hierarchical)
                }
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

    private var footerNote: some View {
        Text("Status here and in Shortcuts is manual only — it does not reflect the system VPN connection.")
            .font(.footnote)
            .foregroundStyle(.tertiary)
            .multilineTextAlignment(.center)
            .padding(.top, 8)
            .padding(.horizontal, 8)
    }

    private func iconName(for status: VPNStatus) -> String {
        switch status {
        case .work:
            preconditionFailure("Work status uses WorkVPNIcon, not SF Symbol")
        case .external:
            return "globe"
        case .none:
            return "network.slash"
        }
    }

    private func refresh() {
        status = VPNStatusStorage.load()
    }

    private func apply(_ newStatus: VPNStatus) async {
        message = nil
        do {
            if newStatus == .none {
                try await LiveActivityManager.shared.stop()
            } else {
                try await LiveActivityManager.shared.startOrUpdate(status: newStatus)
            }
            refresh()
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
