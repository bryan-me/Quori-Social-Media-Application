//
//  ArtifcialIntelligence.swift
//  Quori
//
//  Created by Bryan Danquah on 21/05/2023.
//

import SwiftUI
import Combine

struct ArtificialIntelligence: View {
    @State private var sharingContent: String = ""
    @State var chatMessages: [ChatMessage] = []
    @State var messageText: String = ""
    @FocusState private var showKeyboard: Bool
    
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @State var isLoading: Bool = false
    
    //Copy Text
    @State  var text: String = ""
    @State private var buttonText: String = "copy"
    
    private let pasteboard = UIPasteboard.general.string
    
    let openAIService = OpenAIService()
    @State var cancellables = Set<AnyCancellable>()
    
    @State private var showTime: Bool = false
    @State private var Loading: Bool = false
    
    
    @State private var isWaitingForResponse = false
    
    @State private var showPopUp = false
   
    var body: some View {

            
            ZStack {
                LinearGradient(colors: [Color("White"), Color("White")], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                VStack {
                    HeaderView()
                    ScrollView {
                        LazyVStack {
                            if chatMessages.isEmpty{
                                    ZStack{
                                        BlurView(style: .systemThinMaterialLight)
                                        
                                        HStack{
                                            VStack{
                                                Image(systemName: "wand.and.stars.inverse")
                                                    .font(.title)
                                                    .fontWeight(.bold)
                                                    .foregroundColor(Color.blue)
                                                    
                                            }
                                            .vAlign(.top)
                                            
                                            Text("I'm QuoriBot, your creative and helpful chatbot. I have limitations and may provide inaccurate information about people, places, or facts, but your feedback will help me improve.")
                                        }
                                        .padding(.all, 15)
                                        .font(.system(size: 16, design: .rounded))
                                        
                                    }
                                        .padding(.top, 30)
                                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                        .shadow(radius: 5, y: 5)
                                        .frame(maxWidth: .infinity)
                                        .padding(.horizontal, 50)
                                        //.frame(height: 200)
                                        .padding(.bottom, 10)
                                    
                            }else{
                                ForEach(chatMessages, id: \.id){message in
                                    messageView(message: message)
                            }
                           
                            }
                        }
                        //.padding()
                        //.padding(.top, 55)
                        .padding(.trailing, -20)
                        .padding(.bottom, 5)
                    }
                    .overlay(
                        Group{
                            if showPopUp {
                                PopUpView()
                            }
                        }
                    )
                    .overlay(alignment: .topLeading){
                        Image("AI")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 150)
                            .shadow(radius: 30)
                            .offset(y: -70)
                    }
                    .padding(.leading, -20)
                    
                    
                    HStack {
                        HStack{
                            CustomTextField(placeholder: Text("Write a message...").font(.subheadline), text: $messageText)
                                
                            
                            if isWaitingForResponse{
                                ProgressView()
                                    .progressViewStyle(DefaultProgressViewStyle())
                                    //.padding()
                            }else{
                                Button{
                                  sendMessage()
                                } label: {
                                    Image(systemName: "paperplane.fill")
                                        .font(.callout)
                                        .foregroundColor(Color.white)
                                        .padding(5)
                                        .background(Color("Cobalt"))
                                        .cornerRadius(50)
                                }
                                .disabled(messageText == "")
                                .opacity(messageText == "" ? 0.6 : 1)
                            }
                        }
                        
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .padding(.leading, 7)
                        .background{
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .stroke(lineWidth: 1)
                                .fill(.gray.opacity(0.7))
                        }
                        .cornerRadius(50)
                        .padding()
                        .padding(.top, -35)
                        .padding(.bottom, -5)
                    }
                    .padding(.top)
                    .background(.white)
                }
                
            }
            .alert(errorMessage, isPresented: $showError, actions: {})
    }
    
    //Sharing Content
    func shareContent() {
          let activityViewController = UIActivityViewController(activityItems: [messageText], applicationActivities: nil)
          UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
      }
    
    //Message View
    func messageView(message: ChatMessage) -> some View{
        VStack(alignment: message.sender == .gpt ? .leading : .trailing) {
           // HStack {
                //if message.sender == .me {Spacer()}
            
                    HStack {
                        Text(message.content)
                            .padding(9)
                            .padding(.horizontal, 5)
                            .font(.callout)
                            .foregroundColor(message.sender == .gpt ? Color.black : Color("White"))
                            .background(message.sender == .gpt ? .gray.opacity(0.3) : Color.black)
                            .cornerRadius(20, corners: message.sender == .gpt ? [.topLeft, .topRight, .bottomRight] : [.topLeft, .topRight, .bottomLeft])
                            .contextMenu{
                                Button(action: {UIPasteboard.general.string = "\(message.content)"
                                    showPopUp = true
                                
                                    //Hide Pop up after delay
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                                        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)){
                                            showPopUp = false
                                        }
                                        
                                    }
                                }){
                                        HStack{
                                            Text(buttonText)
                                            Image(systemName: "doc.on.doc")
                                        }
                                    }
                                
                                Button(action: shareContent){
                                        HStack{
                                            Text("share")
                                            Image(systemName: "square.and.arrow.up")
                                        }
                                    }
                            }
                            
                    }
                    
                    .frame(maxWidth: 300, alignment: message.sender == .gpt ? .leading : .trailing)
                    .onTapGesture {
                        showTime.toggle()
                    }
                    if showTime{
                        Text("\(Date().formatted(.dateTime.hour().minute()))")
                            .font(.caption2)
                            .foregroundColor(Color.gray)
                            .padding(message.sender == .gpt ? .leading : .trailing, 25)
                    }
                
                //if message.sender == .gpt {Spacer()}
                
            //}
        }
        
        .frame(maxWidth: .infinity, alignment: message.sender == .gpt ? .leading : .trailing)
        .padding(message.sender == .gpt ? .leading : .trailing)
        .padding(.horizontal)
    }
        
    
    func sendMessage() {
        let myMessage = ChatMessage(id: UUID().uuidString, content: messageText, dateCreated: Date(), sender: .me)
        chatMessages.append(myMessage)
        isWaitingForResponse = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0){
            openAIService.sendMessage(message: messageText).sink { completion in
                //Handling Error
            }receiveValue: { response in
                guard let textResponse = response.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines.union(.init(charactersIn: "\""))) else {return}
                let gptMessage = ChatMessage(id: response.id, content: textResponse, dateCreated: Date(), sender: .gpt)
                chatMessages.append(gptMessage)
                isWaitingForResponse = false
            }
            .store(in: &cancellables)
            messageText = ""
        }
        
    }
    
    //Simulate Network Call
    func startNetorkCall(){
        Loading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            Loading = false
        }
    }
    


    
    //Display Errors Via Alert
    func setError(_ error: Error)async{
        //UI Must Be Updated On Main Thread
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
            isLoading = false
        })
    }
    
}

//Header View




func hideKeyboard(){
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}



struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ArtificialIntelligence()
    }
}

struct ChatMessage {
    let id: String
    let content: String
    let dateCreated: Date
    let sender: MessageSender
}

struct HeaderView: View{
    //Network Monitor
    @StateObject var networkMonitor = NetworkMonitor() // Use @StateObject instead of @ObservedObject
    @State private var networkStatusText = "Connected" // Initial network status text
    var body: some View{
        HStack(spacing: 10){
            HStack{
                VStack(alignment: .center){
                    Text("Quori Bot")
                        .font(.title.bold())
                    
                    
                    if networkMonitor.isConnected {
                        HStack{
                            Image(systemName: "circle.fill")
                                .font(.caption2)
                                .foregroundColor(.green)
                            
                            Text("Connected")
                                .font(.caption)
                                .foregroundColor(Color.green)
                                .animation(.easeInOut)
                        }
                        } else {
                                    HStack{
                                        Image(systemName: "circle.fill")
                                            .font(.caption2)
                                            .foregroundColor(.red)
                                        
                                        Text("Connecting...")
                                            .font(.caption)
                                            .foregroundColor(.red)
                                            .animation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true))
                                    }
                                }
                    
                }
                .padding(.leading, 40)
                .onReceive(networkMonitor.$isConnected) { isConnected in
                            if isConnected {
                                // Update UI to show connection status
                                networkStatusText = "Connected"
                            } else {
                                // Update UI to show disconnection status
                                networkStatusText = "Connecting..."
                            }
                        }
            }
            .frame(maxWidth: .infinity, alignment: .center)
           
            
            
            ZStack{
                BlurView(style: .systemThinMaterialLight)
                Button{
                    hideKeyboard()
                }label:{
                    Image(systemName: "keyboard.chevron.compact.down")
                    .font(.system(size: 15))
                }
                .padding(.all, 10)
            }
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .frame(width: 30, height: 30)
               
        }
        .padding()
        .padding(.bottom, -5)
        .background{
            VStack(spacing: 0){
                Color.white
                //Gradient Opacity Background
                Rectangle()
                    .fill(.linearGradient(colors:[.white, .clear], startPoint: .top, endPoint: .bottom))
                    .frame(height: 20)
            }
            .ignoresSafeArea()
        }
    }

}

struct PopUpView: View {
    var body: some View {
        ZStack{
            BlurView(style: .systemThinMaterialLight)
            VStack{
                Text("Saved to\nClipboard!")
                    .font(.headline)
                    .padding()
                    .foregroundColor(.black)
                    //.animation(.spring()) // Apply animation to the pop-up
                    .transition(.scale) // Add a scaling transition effect
                    .multilineTextAlignment(.center)
                
                Image(systemName: "checkmark.circle")
                    .font(.system(size: 50))
                    .padding(.bottom)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .shadow(radius: 5, y: 5)
        .frame(width: 170, height: 170)
        //.padding(.bottom, 10)
        
            

    }
}

struct CustomTextArea: View{
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

enum MessageSender {
    case me
    case gpt
}

extension ChatMessage {
    static let sampleMessages = [
        ChatMessage(id: UUID().uuidString, content: "Sample Message From Me", dateCreated: Date(), sender: .me),
        ChatMessage(id: UUID().uuidString, content: "Sample Message From GPT", dateCreated: Date(), sender: .gpt),
        ChatMessage(id: UUID().uuidString, content: "Sample Message From Me", dateCreated: Date(), sender: .me),
        ChatMessage(id: UUID().uuidString, content: "Sample Message From GPT", dateCreated: Date(), sender: .gpt)
    ]
}



