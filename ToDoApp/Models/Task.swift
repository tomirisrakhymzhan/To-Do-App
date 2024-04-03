//
//  Task.swift
//  ToDoApp
//
//  Created by Томирис Рахымжан on 03/04/2024.
//

struct Task: Codable {
    let name: String
    let priority: Priority
    
    enum Priority: String, Codable { // Add Codable conformance to Priority enum
        case low = "Low"
        case medium = "Medium"
        case high = "High"
    }
}
