import SwiftUI

/// Shared LA icon used across app and Live Activity.
struct StatusIcon: View {
    var size: CGFloat = 24
    var systemName: String = "network"
    var accessibilityLabel: String?

    var body: some View {
        let icon = Image(systemName: systemName)
            .font(.system(size: size * 0.85, weight: .medium))
            .symbolRenderingMode(.hierarchical)
            .frame(width: size, height: size)

        if let accessibilityLabel, !accessibilityLabel.isEmpty {
            icon.accessibilityLabel(accessibilityLabel)
        } else {
            icon.accessibilityHidden(true)
        }
    }
}
