import ActivityKit
import SwiftUI
import WidgetKit

struct VPNStatusLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: VPNActivityAttributes.self) { context in
            VStack(alignment: .leading, spacing: 4) {
                Label {
                    Text(context.state.displayTitle)
                        .font(.headline)
                } icon: {
                    statusIcon(for: context.state, size: 24)
                }
            }
            .padding()
            .activityBackgroundTint(Color.black.opacity(0.35))
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    statusIcon(for: context.state, size: 28)
                }
                DynamicIslandExpandedRegion(.center) {
                    Text(context.state.displayTitle)
                        .font(.headline)
                }
            } compactLeading: {
                statusIcon(for: context.state, size: 18)
            } compactTrailing: {
                Text(context.state.shortLabel)
                    .font(.caption2.weight(.semibold))
                    .minimumScaleFactor(0.5)
            } minimal: {
                statusIcon(for: context.state, size: 14)
            }
            .keylineTint(Color.accentColor)
        }
    }

    @ViewBuilder
    private func statusIcon(for state: VPNActivityAttributes.ContentState, size: CGFloat) -> some View {
        if state.shortLabel == VPNStatus.work.shortLabel {
            WorkVPNIcon(size: size)
        } else {
            Image(systemName: symbolName(for: state))
                .font(.system(size: size * 0.85, weight: .medium))
                .symbolRenderingMode(.hierarchical)
        }
    }

    private func symbolName(for state: VPNActivityAttributes.ContentState) -> String {
        switch state.shortLabel {
        case VPNStatus.external.shortLabel:
            return "globe"
        case VPNStatus.none.shortLabel:
            return "network.slash"
        default:
            return "network"
        }
    }
}
