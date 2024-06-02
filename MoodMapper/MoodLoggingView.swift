//
//  MoodLoggingView.swift
//  MoodMapper
//
//  Created by Rohan Sharma on 5/30/24.
//

import SwiftUI

struct MoodLoggingView: View {
    @Binding var moodEntries: [MoodEntry]
    @State private var selectedMood: String = "Happy"
    @State private var moodNote: String = ""
    @State private var showAlert = false
    @State private var entryToDelete: MoodEntry?

    let moods = ["Happy", "Sad", "Anxious", "Calm"]

    var body: some View {
        GeometryReader { geometry in
            VStack {
                VStack(spacing: 20) {
                    Picker("Select your mood", selection: $selectedMood) {
                        ForEach(moods, id: \.self) { mood in
                            Text(mood)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)

                    TextField("Add a note...", text: $moodNote)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    Button(action: {
                        let newEntry = MoodEntry(mood: selectedMood, note: moodNote, date: Date())
                        moodEntries.append(newEntry)
                        saveMoodEntries()
                        moodNote = ""
                        UIApplication.shared.endEditing() // Dismiss the keyboard
                    }) {
                        Text("Save Mood")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .shadow(radius: 5)
                .frame(width: geometry.size.width * 0.9)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 3) // Center the form in the upper part of the screen

                List {
                    ForEach(moodEntries) { entry in
                        VStack(alignment: .leading) {
                            Text(entry.mood)
                                .font(.headline)
                            Text(entry.note)
                            Text(entry.date, style: .date)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                entryToDelete = entry
                                showAlert = true
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .frame(width: geometry.size.width, height: geometry.size.height * 0.5)
            }
            .navigationTitle("Add Mood")
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Delete Entry"),
                    message: Text("Are you sure you want to delete this entry?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let entry = entryToDelete {
                            delete(entry)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }

    func saveMoodEntries() {
        if let encoded = try? JSONEncoder().encode(moodEntries) {
            UserDefaults.standard.set(encoded, forKey: "MoodEntries")
        }
    }

    func delete(_ entry: MoodEntry) {
        if let index = moodEntries.firstIndex(where: { $0.id == entry.id }) {
            moodEntries.remove(at: index)
            saveMoodEntries()
        }
    }
}

struct MoodLoggingView_Previews: PreviewProvider {
    static var previews: some View {
        MoodLoggingView(moodEntries: .constant([]))
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
