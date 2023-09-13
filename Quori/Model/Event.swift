//
//  Event.swift
//  Quori
//
//  Created by Bryan Danquah on 21/05/2023.
//

import SwiftUI

//Task Model
struct Event: Identifiable{
    var id: UUID = .init()
    var dateAdded: Date
    var taskName: String
    var taskDescription: String
    var taskCategory: Category
}

//Sample Task
var sampleEvents: [Event] = [
    .init(dateAdded: Date(timeIntervalSince1970: 1672829809), taskName: "Edit Youtube Video", taskDescription: "", taskCategory: .Study),
    .init(dateAdded: Date(timeIntervalSince1970: 1672829809), taskName: "Matched Geometry Effect(Issue)", taskDescription: "", taskCategory: .Deadline),
    .init(dateAdded: Date(timeIntervalSince1970: 1672829809), taskName: "Multi-ScrollView", taskDescription: "", taskCategory: .Assignment),
    .init(dateAdded: Date(timeIntervalSince1970: 1672829809), taskName: "Loreal Ipsum", taskDescription: "Lorem Ipsum is simply a dummy text of the printing and tysetting industry. Lorem ipsum has been the industry's standard dummy text ever since the 1500s.", taskCategory: .Event),
    .init(dateAdded: Date(timeIntervalSince1970: 1672829809), taskName: "Complete UI Animation Challenge", taskDescription: "", taskCategory: .Assignment),
    .init(dateAdded: Date(timeIntervalSince1970: 1672829809), taskName: "Fix Shadow Issue on Mockups", taskDescription: "", taskCategory: .Deadline),
    .init(dateAdded: Date(timeIntervalSince1970: 1672829809), taskName: "Add Shadow Effect in Mockview App", taskDescription: "", taskCategory: .Admin_Task),
    .init(dateAdded: Date(timeIntervalSince1970: 1672829809), taskName: "Twitter/Instagram Post", taskDescription: "", taskCategory: .Study),
    .init(dateAdded: Date(timeIntervalSince1970: 1672829809), taskName: "Lorem Ipsum", taskDescription: "", taskCategory: .Lecture),
]
