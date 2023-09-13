//
//  ScheduledNotifications.swift
//  Quori
//
//  Created by Bryan Danquah on 21/05/2023.
//

import SwiftUI
import UserNotifications

struct ScheduledNotifications: View {
    var body: some View {
        VStack{
            //Ask user for permission to show notifications
            Button("Request  Permission"){
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge]) {
                    success, error in
                    if success {
                        print("All Set!")
                    }else if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
            Button("Schedule Notification"){
                //Creating Content of Notification
                let content = UNMutableNotificationContent()
                content.title = "Call Emma"
                content.subtitle = "You have to know what is happening"
                content.sound = UNNotificationSound.default
                
                //Creating a Trigger
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                
                //Creating a Request
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request)
            }
        }
    }
}

struct ScheduledNotifications_Previews: PreviewProvider {
    static var previews: some View {
        ScheduledNotifications()
    }
}
