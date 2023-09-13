//
//  Onboarding.swift
//  Quori
//
//  Created by Bryan Danquah on 21/05/2023.
//

import SwiftUI
struct Onboarding: View {
    @AppStorage("currentPage") var currentPage = 1
   
    var body: some View {
        if currentPage > totalPages {
           House()
        }else{
            WalkthroughScreen()
        }

       
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding()
            .previewInterfaceOrientation(.portrait)
    }
}

//House Page..
struct House: View{
    @AppStorage("log_status") var logStatus: Bool = false
    var body: some View{
        if logStatus{
            MainView()
                .preferredColorScheme(.light)
        }else{
            LoginView()
                .preferredColorScheme(.light)
        }
    }
}


//Walk through screen
struct WalkthroughScreen: View{
    @AppStorage("currentPage") var currentPage = 1
    var body: some View{
        
        //Slide Animation
        ZStack{
            //Chamging Between Views
            if currentPage == 1 {
                ScreenView(image: "dazzle-line-man-programmer-writing-code-on-a-laptop-1", detail: "Connect and engage with fellow students and faculty.", title: "Welcome to our university community!", bgColor: .yellow)
                    .transition(.scale)
            }
            if currentPage == 2 {
                ScreenView(image: "dazzle-line-boy-talks-to-a-psychologist-online", detail: "Explore real-time messaging, event notifications for seamless communication.", title: "Key Features", bgColor: .blue)
                    .transition(.scale)
            }
            if currentPage == 3 {
                ScreenView(image: "dazzle-line-man-looks-at-the-resumes-of-candidates-for-a-vacancy-1", detail: "Create your profile, personalize your settings, and start building meaningful connections within the community.", title: "Get Started...", bgColor: .pink)
                    .transition(.scale)
                
            }
                
            
        }
        
        .overlay(
            
            //Button
            Button(action: {
                //Changing Views
                withAnimation(.easeOut){
                    // Check
                    if currentPage <= totalPages{
                        currentPage += 1
                    }
                    else{
                        currentPage = 1
                    }
                }
            }, label: {
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                    .frame(width: 60, height: 60)
                    .background(.white)
                    .clipShape(Rectangle())
                    .cornerRadius(20)

                
                //Circular Slider
                    .overlay(
                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.black.opacity(0.1), lineWidth: 4)
                            
                            
                            RoundedRectangle(cornerRadius: 20)
                                .trim(from: 0, to: CGFloat(currentPage) / CGFloat(totalPages))
                                .stroke(Color.white, lineWidth: 4)
                                .rotationEffect(.init(degrees: -90))
                        }
                            .padding(-15)
                    )
            })
            .padding(.bottom, 20)
            .padding(.leading, 220)
            ,alignment: .bottom
        )
    }
}

struct ScreenView: View {
    var image: String
    var detail: String
    var title: String
    var bgColor: Color
    
    @AppStorage("currentPage") var currentPage = 1
    var body: some View {
        VStack(spacing: 10){
            HStack{
                //Showing for first page only
                if(currentPage == 1){
                    Text("Hey there👋")
                        .font(.title)
                        .fontWeight(.semibold)
                    //Letter Spacing
                        .kerning(1.4)
                }else{
                    //Back Button
                    Button(action: {
                        withAnimation(.easeOut){
                            currentPage -= 1
                        }
                    }, label: {
                        
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .background(Color.black.opacity(0.4))
                            .cornerRadius(10)
                       
                    })
                }

                
                Spacer()
                
                Button(action: {
                    withAnimation(.easeOut){
                        currentPage = 4
                    }
                }, label: {
                    Text("Skip")
                        .fontWeight(.semibold)
                        .kerning(1.2)
                })
            }
            .foregroundColor(.black)
            .padding()
            
            Spacer(minLength: 0)
            
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.top)
                .multilineTextAlignment(.leading)
            
            Text(detail)
                .fontWeight(.semibold)
                .kerning(1.3)
                .multilineTextAlignment(.leading)
            
            
            //Minimum spacing when phone is reducing
            Spacer(minLength: 120)
        }
        .background(bgColor.ignoresSafeArea())
    }
}

//Total Pages
var totalPages = 3
