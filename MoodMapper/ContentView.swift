//
//  ContentView.swift
//  MoodMapper
//
//  Created by Rohan Sharma on 5/27/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedMood: String = "Happy"
    @State private var moodNote: String = ""
    @State private var moodEntries: [MoodEntry] = []

    let moods = ["Happy", "Sad", "Anxious", "Calm"]

    var body: some View {
        NavigationView {
            VStack {
                Picker("Select your mood", selection: $selectedMood) {
                    ForEach(moods, id: \.self) { mood in
                        Text(mood)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                TextField("Add a note...", text: $moodNote)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    let newEntry = MoodEntry(mood: selectedMood, note: moodNote, date: Date())
                    moodEntries.append(newEntry)
                    saveMoodEntries()
                    moodNote = ""
                }) {
                    Text("Save Mood")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()

                List(moodEntries) { entry in
                    VStack(alignment: .leading) {
                        Text(entry.mood)
                            .font(.headline)
                        Text(entry.note)
                        Text(entry.date, style: .date)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("MoodMapper")
            .onAppear(perform: loadMoodEntries)
        }
    }

    func saveMoodEntries() {
        if let encoded = try? JSONEncoder().encode(moodEntries) {
            UserDefaults.standard.set(encoded, forKey: "MoodEntries")
        }
    }

    func loadMoodEntries() {
        if let savedEntries = UserDefaults.standard.data(forKey: "MoodEntries"),
           let decodedEntries = try? JSONDecoder().decode([MoodEntry].self, from: savedEntries) {
            moodEntries = decodedEntries
        }
    }
}

struct MoodEntry: Identifiable, Codable {
    var id = UUID()
    let mood: String
    let note: String
    let date: Date
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
