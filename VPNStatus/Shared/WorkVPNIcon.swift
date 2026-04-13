import SwiftUI

/// Renders the **WorkVPN** image asset (same artwork as the app icon) for Work VPN affordances.
struct WorkVPNIcon: View {
    var size: CGFloat = 24

    var body: some View {
        Image("WorkVPN")
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .clipShape(RoundedRectangle(cornerRadius: size * 0.2237, style: .continuous))
            .accessibilityLabel("Work VPN")
    }
}
