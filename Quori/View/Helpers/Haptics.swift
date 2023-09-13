//
//  Haptics.swift
//  Quori
//
//  Created by Bryan Danquah on 26/05/2023.
//

import SwiftUI

class HapticManager{
    static let instance = HapticManager() // Singleton
    
    func notifications(type: UINotificationFeedbackGenerator.FeedbackType){
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle){
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}

struct Haptics: View {
    var body: some View {
        VStack(spacing: 20){
            Button("success"){HapticManager.instance.notifications(type: .success)}
            Button("warning"){HapticManager.instance.notifications(type: .warning)}
            Button("error"){HapticManager.instance.notifications(type: .error)}
            Divider()
            Button("light"){HapticManager.instance.impact(style: .light)}
            Button("medium"){HapticManager.instance.impact(style: .medium)}
            Button("heavy"){HapticManager.instance.impact(style: .heavy)}
            Button("rigid"){HapticManager.instance.impact(style: .rigid)}
            Button("soft"){HapticManager.instance.impact(style: .soft)}
        }
    }
}

struct Haptics_Previews: PreviewProvider {
    static var previews: some View {
        Haptics()
    }
}
