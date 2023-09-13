//
//  SplashScreen2.swift
//  Quori
//
//  Created by Bryan Danquah on 21/05/2023.
//

import SwiftUI

struct SplashScreen2: View {
    @State var startAnimation: Bool = false
    @State var circleAnimation1: Bool = false
    @State var circleAnimation2: Bool = false

    //Show Name
    @State var showName: Bool = false
    
    //End Animation
    @Binding var endAnimation: Bool
    
    @State var colorChange: Bool = false
    
    @State var delay: Bool = false
    var body: some View {
        ZStack{
//            Color(.blue)
            LinearGradient(colors: [Color("Vermilion")], startPoint: .topLeading, endPoint: .bottomTrailing)
            
            ZStack{
                Group{
                    //Image("SplashImage")
                    Image(systemName: "newspaper.fill")
                        .foregroundColor(Color("White"))
                        .font(.system(size: 300))
                        .shadow(radius: 30)
                    Name()
                        .frame(width: 400, height: 200)
                        .scaleEffect(showName ? 1: 0)
                        .offset(x: 0, y: 320)
                }
                .frame(width: 220, height: 130)
                .scaleEffect(endAnimation ? 0.35 : 0.6)
                .rotationEffect(endAnimation ? .init(degrees: 0): .init(degrees: 360))
            }
            VStack{
                Text("Version 1.0")
                    .font(.callout)
                    .fontWeight(.semibold)
                   
                
                
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .foregroundColor(.white.opacity(0.8))
            .padding(.bottom, getSafeArea().bottom == 0 ? 15 : getSafeArea().bottom)
            .opacity(startAnimation ? 1 : 0)
            .opacity(endAnimation ? 0 : 1)
        }
        //Changing View
        .offset(x: delay ? -(getRect().width * 1) : 0)
        .ignoresSafeArea()
        .onAppear{
            //Delay Start
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.30){
                
                //First Circle
                withAnimation(.spring()){
                    circleAnimation1.toggle()
                }
                
                //Next Shape
                withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 1.05, blendDuration: 1.05).delay(0.3)){
                    startAnimation.toggle()
                }
                
                
                //Final Circle
                withAnimation(.spring().delay(0.7)){
                    circleAnimation2.toggle()
                }
                
                //end Animation
                withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 1.05, blendDuration: 0.3).delay(1.2)){
                    endAnimation.toggle()
                }
               
                withAnimation(.spring().delay(2.3)){
                    showName.toggle()
                }
                
                withAnimation(.spring().delay(3.5)){
                    delay.toggle()
                }
//                withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 1.05, blendDuration: 0.3).delay(2.3)){
//                    showName.toggle()
//                }
            }
            
        }

    }
}

struct SplashScreen2_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .background(Color("Vermilion").gradient)
            .previewInterfaceOrientation(.portrait)
    }
}



