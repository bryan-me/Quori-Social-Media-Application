//
//  Message.swift
//  Quori
//
//  Created by Bryan Danquah on 21/05/2023.
//

import Foundation

struct Message: Identifiable, Codable{
    var id: String
    var text: String
    var received: Bool
    var timestamp: Date
}
