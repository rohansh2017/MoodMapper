//
//  MoodEntry.swift
//  MoodMapper
//
//  Created by Rohan Sharma on 5/30/24.
//

import Foundation

struct MoodEntry: Identifiable, Codable {
    var id = UUID()
    let mood: String
    let note: String
    let date: Date
}

