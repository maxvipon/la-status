import ActivityKit
import SwiftUI
import WidgetKit

struct LAStatusLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LAActivityAttributes.self) { context in
            HStack(spacing: 8) {
                StatusIcon(size: 22)
                Text(context.state.liveActivityLabel)
                    .font(.headline)
            }
            .padding()
            .activityBackgroundTint(Color.black.opacity(0.35))
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    StatusIcon(size: 28)
                }
                DynamicIslandExpandedRegion(.center) {
                    Text(context.state.liveActivityLabel)
                        .font(.subheadline.weight(.semibold))
                }
            } compactLeading: {
                StatusIcon(size: 18)
            } compactTrailing: {
                Text(context.state.dynamicIslandLabel)
                    .font(.caption2.weight(.semibold))
                    .minimumScaleFactor(0.5)
            } minimal: {
                StatusIcon(size: 14)
            }
            .keylineTint(Color.accentColor)
        }
    }
}
