//
//  AI Onboarding.swift
//  Quori
//
//  Created by Bryan Danquah on 27/05/2023.
//

import SwiftUI

struct AI_Onboarding: View {
    @AppStorage("currentPage") var currentPage = 1
   
    var body: some View {
        if currentPage > totalPages {
           House()
        }else{
            WalkthroughScreen()
        }

       
    }
}

struct AI_Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding()
            .previewInterfaceOrientation(.portrait)
    }
}

//House Page..
struct Main: View{
    @AppStorage("log_status") var logStatus: Bool = false
    var body: some View{
        if logStatus{
            ArtificialIntelligence()
                .preferredColorScheme(.light)
        }
    }
}


//Walk through screen
struct Walkthrough: View{
    @AppStorage("currentPage") var currentPage = 1
    var body: some View{
        
        //Slide Animation
        ZStack{
            //Chamging Between Views
            if currentPage == 1 {
                Screen(image: "AI", detail: "", title: "", bgColor: .yellow)
                    .transition(.scale)
            }
        }
        
       
    }
}

struct Screen: View {
    var image: String
    var detail: String
    var title: String
    var bgColor: Color
    
    @AppStorage("currentPage") var currentPage = 1
    var body: some View {
        ZStack{
            LinearGradient(colors: [Color.yellow,Color.pink,Color.purple,Color.blue,Color.cyan], startPoint: .topTrailing, endPoint: .bottomLeading)
                
            BlurView(style: .systemThinMaterialLight)
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 10){
                HStack{
                    //Showing for first page only
                    if(currentPage == 1){
                        Text("Quori\nBot")
                            .font(.system(size: 70, design: .serif))
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                        //Letter Spacing
                            //.kerning(2.4)
                    }
                }
                //.foregroundColor(.black)
                .padding()
                
                //Spacer()
                
                
                
                HStack(alignment: .bottom){
                    ZStack{
                        BlurView(style: .systemThinMaterialLight)
                        VStack{
                            Text("Welcome")
                                .font(.title).bold()
                                .foregroundColor(Color.black)
                                .padding(.vertical)
                            HStack(alignment: .center,spacing: 20){
                                Image(systemName: "scope")
                                    .foregroundColor(Color.pink)
                                Image(systemName: "lock.fill")
                                    .foregroundColor(Color.purple)
                                Image(systemName: "eye.fill")
                                    .foregroundColor(Color.blue)
                            }
                            .font(.title2)
                            .padding(.bottom, 10)
                            VStack(alignment: .center, spacing: 10){
                                Text("Quori Bot's accuracy varies, so be cautious with sensitive information. Chats may be reviewed by AI trainers. ")
                                    .font(.callout)
                                    .foregroundColor(Color.gray)
                                    .kerning(1.3)
                                    .multilineTextAlignment(.center)
                                    
                               
                            }
                            .padding(.horizontal)
                            
                            //Button
                            Button(action: {
                                //Changing Views
                               
                            }, label: {
                                Text("Continue")
                                    //.font(.system(size: 20, weight: .bold))
                                    .font(.title2.bold())
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(.blue)
                                    .clipShape(Rectangle())
                                    .cornerRadius(20)
                            })
                            .padding()
                        }
                    }
                    
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .shadow(radius: 5, y: 5)
                    .frame(height: 300)
                    .padding()
                    .padding(.bottom, 10)
                    
                }
                
                //Minimum spacing when phone is reducing
                Spacer()
            }
        }
    }
}

//Total Pages
var total = 1
