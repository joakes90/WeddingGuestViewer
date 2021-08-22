//
//  GuestViewerWidget.swift
//  GuestViewerWidget
//
//  Created by Justin Oakes on 8/22/21.
//

import WidgetKit
import Firebase
import GuestData
import SwiftUI
import Combine

struct Provider: TimelineProvider {
    
    let firebaseManager = FireBaseManager()
    private var guestsSubscribers = Set<AnyCancellable>()

    func placeholder(in context: Context) -> SimpleEntry {
        let tempData = GuestData(numberOfReplies: 0,
                                 numberOfConfirmedYes: 0,
                                 numberOfConfirmedNo: 0,
                                 totalGuests: 0)
        
        return SimpleEntry(date: Date(), guestData: tempData)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        firebaseManager.getGuests { guests in
            let guestData = GuestData(numberOfReplies: guests.count,
                                      numberOfConfirmedYes: guests.filter({ $0.attending == true}).count,
                                      numberOfConfirmedNo: guests.filter({ $0.attending == false }).count,
                                      totalGuests: (guests.compactMap({ $0.partySize })).reduce(0, +))
            let entry = SimpleEntry(date: Date(), guestData: guestData)
            completion(entry)
        }
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        firebaseManager.getGuests { guests in
            let guestData = GuestData(numberOfReplies: guests.count,
                                      numberOfConfirmedYes: guests.filter({ $0.attending == true}).count,
                                      numberOfConfirmedNo: guests.filter({ $0.attending == false }).count,
                                      totalGuests: (guests.compactMap({ $0.partySize })).reduce(0, +))
            let entry = SimpleEntry(date: Date(), guestData: guestData)
            let timeLine = Timeline(entries: [entry], policy: .after(Date() + Double(3600) ))
            completion(timeLine)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let guestData: GuestData
}

struct GuestViewerWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    var body: some View {
        switch family {
        case .systemSmall:
            WidgetViewSmall(guestsCount: .constant(entry.guestData.totalGuests))
        case .systemMedium:
            WidgetViewMedium(guestData: .constant(entry.guestData))
        default:
            WidgetViewMedium(guestData: .constant(entry.guestData))
        }
    }}

@main
struct GuestViewerWidget: Widget {
    let kind: String = "GuestViewerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            GuestViewerWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Guest Viewer Widget")
        .description("This shows current guest count from springboard.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct GuestViewerWidget_Previews: PreviewProvider {
    static var previews: some View {
        
        let tempData = GuestData(numberOfReplies: 5,
                                 numberOfConfirmedYes: 5,
                                 numberOfConfirmedNo: 0,
                                 totalGuests: 5)
        
        GuestViewerWidgetEntryView(entry: SimpleEntry(date: Date(), guestData: tempData))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
