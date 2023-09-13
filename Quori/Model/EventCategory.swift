//
//  EventCategory.swift
//  Quori
//
//  Created by Bryan Danquah on 21/05/2023.
//

import SwiftUI

//Category Enum With Color
enum Category: String,CaseIterable{
    case Study = "Study"
    case Deadline = "Deadline"
    case Event = "Events"
    case Assignment = "Assignments"
    case Lecture = "Lectures"
    case Admin_Task = "Admin Tasks"
    
    var color: Color{
        switch self {
        case .Study:
            return Color("Vermilion")
        case .Deadline:
            return Color("Cobalt")
        case .Event:
            return Color.yellow
        case .Assignment:
            return Color.gray
        case .Lecture:
            return Color.purple
        case .Admin_Task:
            return Color.green
        }
    }
}

