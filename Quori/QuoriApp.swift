//
//  QuoriApp.swift
//  Quori
//
//  Created by Bryan Danquah on 21/05/2023.
//

import SwiftUI
import Firebase

@main
struct QuoriApp: App {
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
