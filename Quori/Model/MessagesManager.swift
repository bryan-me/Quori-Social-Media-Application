//
//  MessagesManager.swift
//  Quori
//
//  Created by Bryan Danquah on 21/05/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class MessageManager: ObservableObject{
    @Published private(set) var messages: [Message] = []
    @Published private(set) var lastMessageID = ""
    let db = Firestore.firestore()
    
    init() {
        getMessages()
    }
    
    func getMessages() {
        db.collection("messages").addSnapshotListener{ querySnapshot, error in
            guard let documents = querySnapshot?.documents else{
                print("Error fetching documents: \(String(describing: error))")
                return
            }
            
            self.messages = documents.compactMap{document -> Message? in
                do{
                    return try document.data(as: Message.self)
                }catch{
                    print("Error decoding document to message: \(error)")
                    return nil
                }
            }
            self.messages.sort{$0.timestamp < $1.timestamp}
            
            if let id = self.messages.last?.id{
                self.lastMessageID = id
            }
        }
    }
    
    func sendMessage(text: String){
        do{
            let newMessage = Message(id: "\(UUID())", text: text, received: false, timestamp: Date())
            try db.collection("messages").document().setData(from: newMessage)
        }catch{
            print("Error sending message to firebase: \(error)")
        }
    }
}

