//
//  PostsView.swift
//  Quori
//
//  Created by Bryan Danquah on 21/05/2023.
//

import SwiftUI

struct PostsView: View {
    @State private var createNewPost: Bool = false
    @State private var recentPosts: [Post] = []
    @State private var Loading: Bool = false
    @State private var button: Bool = false
    
    var body: some View {
        NavigationStack{

                ReusablePostsView(posts: $recentPosts)
                    .onAppear{loadingData()}
                    //.redacted(reason: Loading ? .placeholder : [])
                    .hAlign(.center).vAlign(.center)
                    
                    .toolbar(content: {
                        ToolbarItem(placement: .navigationBarLeading){
                            NavigationLink {
                                ProfileView()
                            }label: {
                                Image(systemName: "person.fill")
                                    .tint(Color.gray)
                                    .scaleEffect(0.9)
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing){
                            NavigationLink {
                                SearchUserView()
                            }label: {
                                Image(systemName: "magnifyingglass")
                                    .tint(Color.gray)
                                    .scaleEffect(0.9)
                                
                            }
                            
                        }
                        
                    })
                .navigationTitle("Feed")
            
            .overlay(alignment: .bottomTrailing){
            
                Button{
                    createNewPost.toggle()
                }label: {
                    Image(systemName: "plus.rectangle.fill.on.rectangle.fill")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .frame(width: 35, height: 35)
                        .foregroundColor(Color.white)
                        .padding(13)
                        .background(Color("Cobalt"), in: Circle())
                        
                }
                .padding(15)
            }
        }
        .onAppear{
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
            .fullScreenCover(isPresented: $createNewPost){
                CreateNewPost { post in
                    //Adding created Posts To The Top Of Recent Posts
                    recentPosts.insert(post, at: 0)
                }
            }
    }
    func loadingData(){
        Loading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 5){
            Loading = false
        }
    }
}


struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView()
            
    }
}


