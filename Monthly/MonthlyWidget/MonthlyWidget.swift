//
//  MonthlyWidget.swift
//  MonthlyWidget
//
//  Created by Paweł Brzozowski on 30/09/2022.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> DayEntry {
        DayEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (DayEntry) -> ()) {
        let entry = DayEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [DayEntry] = []

        let currentDate = Date()
        for dayOffset in 0 ..< 7 {
            let entryDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentDate)!
            let startOfDate = Calendar.current.startOfDay(for: entryDate)
            let entry = DayEntry(date: startOfDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct DayEntry: TimelineEntry {
    let date: Date
}

struct MonthlyWidgetEntryView : View {
    var entry: DayEntry
    var config: MonthConfig
    
    init(entry: DayEntry) {
        self.entry = entry
        self.config = MonthConfig.determineConfig(from: self.entry.date)
    }
    
    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(config.backgroundColor.gradient)
            VStack {
                HStack(spacing: 4) {
                    Text(config.emojiText)
                        .font(.title)
                    Text(entry.date.weekdayFormat)
                        .font(.title3)
                        .fontWeight(.bold)
                        .minimumScaleFactor(0.6)
                        .foregroundColor(config.weekdayTextColor.opacity(0.6))
                    Spacer()
                }
                
                Text(entry.date.dayFormat)
                    .font(.system(size: 80, weight: .heavy))
                    .foregroundColor(config.dayTextColor.opacity(0.8))
                
                
            }
            .padding()
        }
    }
}

@main
struct MonthlyWidget: Widget {
    let kind: String = "MonthlyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MonthlyWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Monthly Style Widget")
        .description("The theme of the widget changes based on month")
        .supportedFamilies([.systemSmall])
    }
}

struct MonthlyWidget_Previews: PreviewProvider {
    static var previews: some View {
        MonthlyWidgetEntryView(entry: DayEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

extension Date {
    var weekdayFormat: String {
        self.formatted(.dateTime.weekday(.wide))
    }
    var dayFormat: String {
        self.formatted(.dateTime.day())
    }
}
