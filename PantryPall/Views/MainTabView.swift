//
//  MainTabView.swift
//  PantryPall
//
//  Created by Arief Catur on 21/08/25.
//
import SwiftUI

struct MainTabView: View {
@AppStorage("useDarkMode") private var useDarkMode = false


var body: some View {
TabView {
PantryDashboardView()
.tabItem { Label("Dashboard", systemImage: "rectangle.grid.2x2.fill") }


PantryListView()
.tabItem { Label("List", systemImage: "list.bullet") }
}
// Terapkan preferensi tema ke seluruh tab
.preferredColorScheme(useDarkMode ? .dark : .light)
}
}


#Preview("Tabs – Light") {
MainTabView()
.modelContainer(previewContainer)
.onAppear { UserDefaults.standard.set(false, forKey: "useDarkMode") }
}
