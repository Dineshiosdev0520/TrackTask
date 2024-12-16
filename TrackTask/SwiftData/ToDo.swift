//
//  ToDo.swift
//  TrackTask
//
//  Created by Dinesh Dev on 08/12/24.
//

import Foundation
import SwiftData
import SwiftUICore

@Model
class Todo {
    @Attribute(.unique) var id: UUID = UUID()
    var task: String
    var desc: String
    var status: TaskStatus
    var priority: Priority
    var lastUpdated: Date
    var family: String

    init(task: String, desc: String, priority: Priority, family: String,date:Date,status:TaskStatus) {
        self.task = task
        self.desc = desc
        self.priority = priority
        self.family = family
        self.lastUpdated = date
        self.status = status
    }
}


enum Priority:String,Codable,CaseIterable{
    case normal = "Normal"
    case medium = "Medium"
    case high = "High"
    
    var color:Color{
        switch self {
        case .normal:
            return .green
        case .medium:
            return .orange
        case .high:
            return .red
        }
    }
}

enum TaskStatus: String,Codable,CaseIterable {
    case active = "Active"
    case pending = "Pending"
    case completed = "Completed"
}

