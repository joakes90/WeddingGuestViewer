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

struct Provider: TimelineProvider {
    
    let firebaseManager = FireBaseManager()

    func placeholder(in context: Context) -> SimpleEntry {
        let tempData = GuestData(numberOfReplies: 0,
                                 numberOfConfirmedYes: 0,
                                 numberOfConfirmedNo: 0,
                                 totalGuests: 0)
        
        return SimpleEntry(date: Date(), guestData: tempData)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        
        FirebaseApp.configure()
        
        let tempData = GuestData(numberOfReplies: 0,
                                 numberOfConfirmedYes: 0,
                                 numberOfConfirmedNo: 0,
                                 totalGuests: 0)
        
        let entry = SimpleEntry(date: Date(), guestData: tempData)
        
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        let tempData = GuestData(numberOfReplies: 0,
                                 numberOfConfirmedYes: 0,
                                 numberOfConfirmedNo: 0,
                                 totalGuests: 0)
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, guestData: tempData)
            entries.append(entry)
        }
        // TODO: Schedual update
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let guestData: GuestData
}

struct GuestViewerWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.date, style: .time)
    }
}

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
        
        let tempData = GuestData(numberOfReplies: 0,
                                 numberOfConfirmedYes: 0,
                                 numberOfConfirmedNo: 0,
                                 totalGuests: 0)
        
        GuestViewerWidgetEntryView(entry: SimpleEntry(date: Date(), guestData: tempData))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
