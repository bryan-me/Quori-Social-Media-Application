//
//  PicView.swift
//  Quori
//
//  Created by Bryan Danquah on 21/05/2023.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseStorage

struct PicView: View {
    @State var isZoomed = false
    @State var offset = CGSize.zero
    
    var post: Post
    
    var body: some View {
        if let postImageURL = post.imageURL{
            VStack {
                if isZoomed {
                    NavigationView {
                        ZStack{
                            Color("Black")
                                .ignoresSafeArea()
                                .toolbar(content: {
                                    ToolbarItem(placement: .navigationBarLeading){
                                        Button(action: {
                                            self.isZoomed.toggle()
                                        }) {
                                            Image(systemName: "xmark")
                                                .font(.subheadline)
                                                .tint(Color.white)
                                                .scaleEffect(0.9)
                                        }
                                    }
                                    
                                })
                            
                            VStack{
                                WebImage(url: postImageURL)
                                    .resizable()
                                    .scaledToFit()
                                    .offset(y: offset.height)
                                //.animation(.interactiveSpring())
                                
                            }
                        }
                        
                    }
                    
                } else {
                    GeometryReader{
                        let size = $0.size
                        WebImage(url: postImageURL)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                    .frame(height: 200)
                    .onTapGesture {
                        self.isZoomed.toggle()
                    }
                }
            }
        }
    }
}

@ViewBuilder
func BottomButtons(Image: String)-> some View{
    
}

struct PicView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
