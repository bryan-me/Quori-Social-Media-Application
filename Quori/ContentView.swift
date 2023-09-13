//
//  ContentView.swift
//  Quori
//
//  Created by Bryan Danquah on 21/05/2023.
//

import SwiftUI

struct ContentView: View {
    @State var endAnimation: Bool = false
    
    var body: some View {
       //Redirecting User Based On Log Status
       
        ZStack{
            Onboarding()
                .offset(y: endAnimation ? 0 : getRect().height)
            
            SplashScreen2(endAnimation: $endAnimation)
        }
        .preferredColorScheme(.light)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

