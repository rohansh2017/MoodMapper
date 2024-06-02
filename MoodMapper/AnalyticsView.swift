//
//  AnalyticsView.swift
//  MoodMapper
//
//  Created by Rohan Sharma on 5/28/24.
//

import SwiftUI

struct AnalyticsView: View {
    var moodEntries: [MoodEntry]

    var body: some View {
        VStack {
            Text("Mood Analytics")
                .font(.largeTitle)
                .padding()

            List {
                ForEach(groupedMoodEntries.keys.sorted(), id: \.self) { mood in
                    HStack {
                        Text(mood)
                        Spacer()
                        Text("\(groupedMoodEntries[mood]?.count ?? 0)")
                    }
                }
            }
        }
    }

    var groupedMoodEntries: [String: [MoodEntry]] {
        Dictionary(grouping: moodEntries, by: { $0.mood })
    }
}

struct AnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsView(moodEntries: [
            MoodEntry(mood: "Happy", note: "Had a great day!", date: Date()),
            MoodEntry(mood: "Sad", note: "Not feeling well.", date: Date())
        ])
    }
}
