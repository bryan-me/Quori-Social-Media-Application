//
//  ReusablePostsView.swift
//  Quori
//
//  Created by Bryan Danquah on 21/05/2023.
//

import SwiftUI
import Firebase

struct ReusablePostsView: View {
    var basedOnUID: Bool = false
    var uid: String = ""
    @Binding var posts: [Post]
    
    //View Properties
    @State private var isFetching: Bool = false
    
    //Pagination
    @State private var paginationDoc: QueryDocumentSnapshot?
    
    var body: some View {
        CustomRefreshView(showsIndicator: false){
                    LazyVStack{
                        if posts.isEmpty{
                            //No Posts Found On Firestore
                            VStack{
                                VStack {
                                    HStack{
                                        VStack{
                                            Circle()
                                                .frame(width: 35, height: 35)
                                            
                                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                .fill(.gray)
                                                .frame(width: 5, height: 200)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 6){
                                            RoundedRectangle(cornerRadius: 4)
                                                .frame(height: 10)
                                                .padding(.trailing, 100)
                                            RoundedRectangle(cornerRadius: 4)
                                                .frame(height: 10)
                                                .padding(.trailing, 150)
                                            RoundedRectangle(cornerRadius: 4)
                                                .frame(height: 10)
                                                .padding(.trailing, 200)
                                            
                                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                .frame(height: 200)
                                            
                                            RoundedRectangle(cornerRadius: 4)
                                                .frame(height: 10)
                                                .padding(.trailing, 200)
                                        }
                                    }
                                    
                                    //.padding(.horizontal, 30)
                                 
                                }
                                .padding(15)
                                .shimmer(.init(tint: .gray.opacity(0.3), highlight: .white, blur: 5))
                                
                                VStack {
                                    HStack{
                                        VStack{
                                            Circle()
                                                .frame(width: 35, height: 35)
                                            
                                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                .fill(.gray)
                                                .frame(width: 5, height: 200)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 6){
                                            RoundedRectangle(cornerRadius: 4)
                                                .frame(height: 10)
                                                .padding(.trailing, 100)
                                            RoundedRectangle(cornerRadius: 4)
                                                .frame(height: 10)
                                                .padding(.trailing, 150)
                                            RoundedRectangle(cornerRadius: 4)
                                                .frame(height: 10)
                                                .padding(.trailing, 200)
                                            
                                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                .frame(height: 200)
                                            
                                            RoundedRectangle(cornerRadius: 4)
                                                .frame(height: 10)
                                                .padding(.trailing, 200)
                                        }
                                    }
                                    
                                    //.padding(.horizontal, 30)
                                 
                                }
                                .padding(15)
                                .shimmer(.init(tint: .gray.opacity(0.3), highlight: .white, blur: 5))
                                
                                VStack {
                                    HStack{
                                        VStack{
                                            Circle()
                                                .frame(width: 35, height: 35)
                                            
                                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                .fill(.gray)
                                                .frame(width: 5, height: 200)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 6){
                                            RoundedRectangle(cornerRadius: 4)
                                                .frame(height: 10)
                                                .padding(.trailing, 100)
                                            RoundedRectangle(cornerRadius: 4)
                                                .frame(height: 10)
                                                .padding(.trailing, 150)
                                            RoundedRectangle(cornerRadius: 4)
                                                .frame(height: 10)
                                                .padding(.trailing, 200)
                                            
                                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                .frame(height: 200)
                                            
                                            RoundedRectangle(cornerRadius: 4)
                                                .frame(height: 10)
                                                .padding(.trailing, 200)
                                        }
                                    }
                                    
                                    //.padding(.horizontal, 30)
                                 
                                }
                                .padding(15)
                                .shimmer(.init(tint: .gray.opacity(0.3), highlight: .white, blur: 5))
                                
                            }
                        }else{
                            //Displaying Posts
                            VStack{
                                Text("TRENDING🔥")
                                    .font(.caption).bold()
                                    .padding(.horizontal)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                
                                TrendingView()
                                
                                Divider()
                            }
                            Posts()
                            
                        }
                    }
                    .padding(15)
                }onRefresh:{
                    //Disabling Refresh For UID Based Posts
                    guard !basedOnUID else{return}
                    isFetching = true
                    posts = []
                    
                    //Resetting Pagination Document
                    paginationDoc = nil
                    await fetchPosts()
                }
                .task {
                    guard posts.isEmpty else{return}
                    await fetchPosts()
                }
        

    }
    //Displaying Fetched Posts
    @ViewBuilder
    func Posts() -> some View{
        ForEach(posts){post in
            PostCardView(post: post){ updatePost in
                //Updating Posts In Array
                if let index = posts.firstIndex(where: {post in
                    post.id == updatePost.id
                }){
                    posts[index].likedIDs = updatePost.likedIDs
                    posts[index].dislikedIDs = updatePost.dislikedIDs
                }
            } onDelete: {
                //Removing Post From Array
                withAnimation(.easeInOut(duration: 0.25)){
                    posts.removeAll{post.id == $0.id}
                }
            }
            .onAppear{
                //Fetch New post after last post appears if any
                if post.id == posts.last?.id && paginationDoc != nil{
                    Task{await fetchPosts()}
                }
            }
            Divider()
                .padding(.horizontal, -15)
        }
    }
    
    //Fetching Posts
    func fetchPosts()async{
        do{
            var query: Query!
            
            //Implementing Pagination
            if let paginationDoc{
                query = Firestore.firestore().collection("Posts")
                    .order(by: "publishedDate", descending: true)
                    .start(afterDocument: paginationDoc)
                    .limit(to: 20)
            }else{
                query = Firestore.firestore().collection("Posts")
                    .order(by: "publishedDate", descending: true)
                    .limit(to: 20)
            }
            //New Query For UID Based On Document Fetch
            if basedOnUID{
                query = query
                    .whereField("userUID", isEqualTo: uid)
            }
          
            let docs = try await query.getDocuments()
            let fetchedPosts = docs.documents.compactMap{doc -> Post? in
                try? doc.data(as: Post.self)
            }
            await MainActor.run(body: {
                posts.append(contentsOf: fetchedPosts)
                paginationDoc = docs.documents.last
                isFetching = false
            })
        }catch{
            print(error.localizedDescription)
        }
    }
}

struct ReusablePostsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
