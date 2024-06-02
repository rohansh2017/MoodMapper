//
//  ContentView.swift
//  MoodMapper
//
//  Created by Rohan Sharma on 5/27/24.
//

import SwiftUI

struct ContentView: View {
    @State private var moodEntries: [MoodEntry] = []

    var body: some View {
        TabView {
            MoodLoggingView(moodEntries: $moodEntries)
                .tabItem {
                    Label("Add Mood", systemImage: "pencil.circle")
                }

            AnalyticsView(moodEntries: moodEntries)
                .tabItem {
                    Label("Analytics", systemImage: "chart.bar")
                }
        }
        .onAppear(perform: loadMoodEntries)
    }

    func loadMoodEntries() {
        if let savedEntries = UserDefaults.standard.data(forKey: "MoodEntries"),
           let decodedEntries = try? JSONDecoder().decode([MoodEntry].self, from: savedEntries) {
            moodEntries = decodedEntries
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
