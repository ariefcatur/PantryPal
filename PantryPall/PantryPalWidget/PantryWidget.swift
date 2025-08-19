//
//  PantryWidget.swift
//  PantryPall
//
//  Created by Arief Catur on 19/08/25.
//

import WidgetKit
import SwiftUI
import SwiftData

struct Provider: TimelineProvider {
    func placeholder(in: Context) -> Entry { Entry(date: .now, count: 3) }
    func getSnapshot(in context: Context, completion: @escaping (Entry)->()) { completion(placeholder(in: context)) }
    func getTimeline(in: Context, completion: @escaping (Timeline<Entry>)->()) {
        // Untuk demo, pakai angka statis; hubungkan ke SwiftData via AppGroup/Sharing jika perlu.
        let timeline = Timeline(entries: [Entry(date: .now, count: 3)], policy: .after(Date().addingTimeInterval(3600)))
        completion(timeline)
    }
}
struct Entry: TimelineEntry { let date: Date; let count: Int }

struct PantryWidgetView: View {
    var entry: Entry
    var body: some View {
        VStack(alignment: .leading) {
            Text("Hampir Expired").font(.caption).bold()
            Spacer()
            Text("\(entry.count)").font(.largeTitle).bold()
            Text("Minggu ini").font(.caption2)
        }.padding()
    }
}


struct PantryPalWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "PantryPalWidget", provider: Provider()) { PantryWidgetView(entry: $0) }
            .configurationDisplayName("Pantry Ringkas")
            .description("Lihat item yang segera kedaluwarsa.")
            .supportedFamilies([.systemSmall, .systemMedium])
    }
}
