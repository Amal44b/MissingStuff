//
//  ListWidjetLiveActivity.swift
//  ListWidjet
//
//  Created by Maryam Mohammad on 06/11/1445 AH.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct ListWidjetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct ListWidjetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ListWidjetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension ListWidjetAttributes {
    fileprivate static var preview: ListWidjetAttributes {
        ListWidjetAttributes(name: "World")
    }
}

extension ListWidjetAttributes.ContentState {
    fileprivate static var smiley: ListWidjetAttributes.ContentState {
        ListWidjetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: ListWidjetAttributes.ContentState {
         ListWidjetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: ListWidjetAttributes.preview) {
   ListWidjetLiveActivity()
} contentStates: {
    ListWidjetAttributes.ContentState.smiley
    ListWidjetAttributes.ContentState.starEyes
}
