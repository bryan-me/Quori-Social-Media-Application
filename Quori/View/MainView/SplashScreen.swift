//
//  SplashScreen.swift
//  Quori
//
//  Created by Bryan Danquah on 21/05/2023.
//

import SwiftUI

struct SplashScreen: View {
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
            LinearGradient(colors: [.red, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
            
            ZStack{
               
                Group{
                    
                    //Custom Shape With Animation
                    SplashShape()
                    //trimming
                        .trim(from: 0, to: startAnimation ? 1 : 0)
                    // Stroke To Get Outline
                        .stroke(Color.white, style: StrokeStyle(lineWidth: 30, lineCap: .round, lineJoin: .round))
                    
                    //Two Circles
                    
                    Capsule()
                        .fill(.white)
                        .frame(width: 29.5, height: 60)
                        .scaleEffect(circleAnimation1 ? 1: 0)
                        .offset(x: -81, y: -85)
                    
                    Circle()
                        .fill(.white)
                        .frame(width: 35, height: 35)
                        .scaleEffect(circleAnimation2 ? 1: 0)
                        .offset(x: 70, y: -120)
                    
                    
                  
                    
                    Name()
                        .frame(width: 400, height: 200)
                        .scaleEffect(showName ? 1: 0)
                        .offset(x: 0, y: 170)
                    
                    DelayTime()
                        .frame(width: 400, height: 200)
                        .scaleEffect(delay ? 1: 0)
                        .offset(x: 0, y: 0)
                }
                //Default Frame
                
                .frame(width: 220, height: 130)
                .scaleEffect(endAnimation ? 0.6 : 0.9)
                //.rotationEffect(.init(degrees: endAnimation ? 720 : 0))
            }
            VStack{
                Text("Powered by")
                    .font(.callout)
                    .fontWeight(.semibold)
                   
                
                Text("KB")
                    .font(.title2)
                    
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15){
                
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

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}

//Extending View To Get Screen Frame
extension View{
    
    func getRect() -> CGRect{
        return UIScreen.main.bounds
    }
    
    //SafeArea
    func getSafeArea()->UIEdgeInsets{
        
        guard let screen =
                UIApplication.shared.connectedScenes.first as?
                UIWindowScene else{
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets
        else{
            return .zero
        }
        return safeArea
    }
}

struct SplashShape : Shape{
    func path(in rect: CGRect) -> Path {
        
        return Path{ path in
            
            let mid = rect.width / 2
            //let height = rect.height
            
            // 80 = 40 Arc Radius
                //path.move(to: CGPoint(x: mid - 80, y: height))
                
                
                path.addArc(center: CGPoint(x: mid - 40, y: 0),
                            radius: 40, startAngle: .init(degrees: 180),
                            endAngle: .zero, clockwise: true)
                
            //Straight Line
                //path.move(to: CGPoint(x: mid, y: height / 2 - 4))
                path.addLine(to: CGPoint(x: mid, y: -40 ))
                path.addLine(to: CGPoint(x: mid, y: 50 ))
                
            //Second Arc
                //path.addArc(center: CGPoint(x: mid + 40, y: 0),
                            //radius: 40, startAngle: .init(degrees: -180),
                            //endAngle: .zero, clockwise: false)
            }
            
    }
}

struct Name: View{
    var body: some View{
        Text("Quori")
            .font(.system(size: 100, design: .serif))
            .fontWeight(.heavy)
            .foregroundColor(Color("White"))
            .padding(.top, -150)
    }
}

struct DelayTime: View{
    var body: some View{
        Text("")
    }
}
