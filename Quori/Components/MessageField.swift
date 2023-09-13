//
//  MessageField.swift
//  Quori
//
//  Created by Bryan Danquah on 21/05/2023.
//

import SwiftUI

struct MessageField: View {
    @State private var message = ""
    @EnvironmentObject var messagesManager: MessageManager
    var body: some View {
        HStack{
            CustomTextField(placeholder: Text("Write a message...").font(.subheadline), text: $message)
                
            
            Button{
                messagesManager.sendMessage(text: message)
                message = ""
            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(Color("White"))
                    .padding(7)
                    .background(Color("Cobalt"))
                    .cornerRadius(50)
            }
            .disabled(message == "")
            .opacity(message == "" ? 0.6 : 1)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(.gray.opacity(0.5))
        .cornerRadius(50)
        .padding()
    }
}

struct MessageField_Previews: PreviewProvider {
    static var previews: some View {
        MessageField()
            .environmentObject(MessageManager())
    }
}

struct CustomTextField: View{
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool) -> () = {_ in}
    var commit: () -> () = {}
    
    var body: some View{
        ZStack(alignment: .leading){
            if text.isEmpty{
                placeholder
                    .opacity(0.5)
            }
            
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
}

