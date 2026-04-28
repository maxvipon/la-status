import SwiftUI

/// Shared LA icon used across app and Live Activity.
struct StatusIcon: View {
    var size: CGFloat = 24
    var systemName: String = "network"

    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: size * 0.85, weight: .medium))
            .symbolRenderingMode(.hierarchical)
            .frame(width: size, height: size)
            .accessibilityLabel("LA")
    }
}
