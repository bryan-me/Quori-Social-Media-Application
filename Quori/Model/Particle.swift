//
//  Particle.swift
//  Quori
//
//  Created by Bryan Danquah on 21/05/2023.
//

import SwiftUI

struct Particle: Identifiable{
    var id: UUID = .init()
    var randomX: CGFloat = 0
    var randomY: CGFloat = 0
    var scale: CGFloat = 1
    var opacity: CGFloat = 1
    
    //Reset Property
    mutating func reset() {
        randomX = 0
        randomY = 0
        scale = 1
        opacity = 1
    }
    }


