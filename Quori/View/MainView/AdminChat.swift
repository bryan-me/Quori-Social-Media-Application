//
//  AdminChat.swift
//  Quori
//
//  Created by Bryan Danquah on 21/05/2023.
//

import SwiftUI

struct AdminChat: View {
    @StateObject var messagesManager = MessageManager()
    var body: some View {
        VStack {
            VStack {
                
                TitleRow()
                
                ScrollViewReader {proxy in
                    ScrollView(.vertical, showsIndicators: true){
                        ForEach(messagesManager.messages, id: \.id){message in
                            MessageBubble(message: message)
                        }
                    }
                    .padding(.top, 10)
                    .background(.white)
                    .cornerRadius(30, corners: [.topLeft, .topRight])
                    .onChange(of: messagesManager.lastMessageID){id in
                        withAnimation{
                            proxy.scrollTo(id, anchor: .bottom)
                        }
                    }
                }
            }
            .background(Color("Vermilion"))
            

            
            MessageField()
                .environmentObject(messagesManager)
                .padding(.top, -20)
                .padding(.bottom, -5)
        }
        .padding(.top, -70)
    }
}

struct AdminChat_Previews: PreviewProvider {
    static var previews: some View {
        AdminChat()
    }
}
