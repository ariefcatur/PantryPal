//
//  PantryPalWidget.swift
//  PantryPall
//
//  Created by Arief Catur on 21/08/25.
//
import WidgetKit
import SwiftUI


struct ExpiryEntry: TimelineEntry {
let date: Date
let count: Int
}


struct Provider: TimelineProvider {
func placeholder(in context: Context) -> ExpiryEntry {
ExpiryEntry(date: .now, count: 3)
}


func getSnapshot(in context: Context, completion: @escaping (ExpiryEntry) -> Void) {
completion(ExpiryEntry(date: .now, count: 3))
}


func getTimeline(in context: Context, completion: @escaping (Timeline<ExpiryEntry>) -> Void) {
let entry = ExpiryEntry(date: .now, count: 3)
let refresh = Calendar.current.date(byAdding: .hour, value: 1, to: .now)!
completion(Timeline(entries: [entry], policy: .after(refresh)))
}
}


struct PantryWidgetView: View {
var entry: Provider.Entry // ExpiryEntry


var body: some View {
VStack(alignment: .leading) {
Text("Hampir Expired").font(.caption).bold()
Spacer()
Text("\(entry.count)").font(.largeTitle).bold()
Text("Minggu ini").font(.caption2)
}
.padding()
}
}


//@main
struct PantryPalWidget: Widget {
var body: some WidgetConfiguration {
StaticConfiguration(kind: "PantryPalWidget", provider: Provider()) { PantryWidgetView(entry: $0) }
.configurationDisplayName("Pantry Ringkas")
.description("Lihat item yang segera kedaluwarsa.")
.supportedFamilies([.systemSmall, .systemMedium])
}
}


#Preview("Widget – Small") {
PantryWidgetView(entry: ExpiryEntry(date: .now, count: 3))
.previewContext(WidgetPreviewContext(family: .systemSmall))
}
