//
//  MessageBubble.swift
//  Quori
//
//  Created by Bryan Danquah on 21/05/2023.
//

import SwiftUI

struct MessageBubble: View {
    var message: Message
    @State private var showTime: Bool = false
    var body: some View {
        VStack(alignment: message.received ? .leading : .trailing){
            HStack{
                Text(message.text)
                    .padding(8)
                    .background(message.received ? Color("Vermilion").opacity(0.8) : Color("Cobalt").opacity(0.8))
                    .cornerRadius(30, corners: message.received ? [.topLeft, .topRight, .bottomRight] : [.topLeft, .topRight, .bottomLeft])
                    .foregroundColor(Color("White"))
            }
            .frame(maxWidth: 300, alignment: message.received ? .leading : .trailing)
            .onTapGesture {
                showTime.toggle()
            }
            if showTime{
                Text("\(message.timestamp.formatted(.dateTime.hour().minute()))")
                    .font(.caption2)
                    .foregroundColor(Color.gray)
                    .padding(message.received ? .leading : .trailing, 25)
            }
        }
        .frame(maxWidth: .infinity, alignment: message.received ? .leading : .trailing)
        .padding(message.received ? .leading : .trailing)
        .padding(.horizontal, 10)
    }
}

struct MessageBubble_Previews: PreviewProvider {
    static var previews: some View {
        MessageBubble(message: Message(id: "3222", text: "Hello World", received: true, timestamp: Date()))
    }
}

