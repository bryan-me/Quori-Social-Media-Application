//
//  TrendingView.swift
//  Quori
//
//  Created by Bryan Danquah on 25/05/2023.
//

import SwiftUI

struct TrendingView: View {
    @State private var showCandidateView: Bool = false
    var body: some View {
        VStack {
            ZStack{
                Image("uccLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                LinearGradient(colors: [Color.clear], startPoint: .leading, endPoint: .trailing)
                BlurView(style: .systemThinMaterial)
                    //.blur(radius: 5)
                
                VStackLayout(spacing: 10){
                    HStack{
                        Image("uccLogo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30)
                        
                        Text("UNIVERSITY OF CAPE COAST")
                            .font(.footnote).bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color.gray.opacity(0.5))
                        
                    }
                    Text("Upcoming Elections")
                        .font(.title2).bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                    
                    Text("Your vote matters. Participate in shaping the future of our university. Exercise your right to vote and have a say in campus leadership.")
                        .font(.caption)
                    
                    
                }
                .padding()
                .padding(.top, 5)
                .foregroundColor(Color.black)
                .frame(maxHeight: .infinity, alignment: .top)
                
                VStack{
                    Button(action: {
                        showCandidateView = true
                        
                    }) {
                        Text("View Candidates")
                            .foregroundColor(.white)
                            .font(.caption)
                            .padding(.all, 10)
                            .background{
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .fill(.blue.gradient)
                            }
                    }
                }
                .fullScreenCover(isPresented: $showCandidateView){
                    MainScreen(showCandidateView: $showCandidateView)
                }
                .padding()
                .frame(maxHeight: .infinity, alignment: .bottom)
                .frame(maxWidth: .infinity, alignment: .trailing)
                
               
            }
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(radius: 5, y: 5)
            .frame(height: 200)
            .padding(.bottom, 10)
        }
    }
}

struct TrendingView_Previews: PreviewProvider {
    static var previews: some View {
        TrendingView()
          
    }
}

