//
//  ReusablePostViews.swift
//  Quori
//
//  Created by Bryan Danquah on 25/05/2023.
//

import SwiftUI
import Firebase

struct ReusablePostsViews: View {
    var basedOnUID: Bool = false
    var uid: String = ""
    @Binding var posts: [Post]
    
    //View Properties
    @State private var isFetching: Bool = false
    
    //Pagination
    @State private var paginationDoc: QueryDocumentSnapshot?
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
                  LazyVStack{
                      if isFetching{
                         ProgressView()
                              .padding(.top, 30)
                      }else{
                          if posts.isEmpty{
                              //No Posts Found On Firestore
                              Text("No Posts Found")
                                  .font(.caption2)
                                  .foregroundColor(Color.gray)
                                  .padding(.top, 30)
                          }else{
                              //Displaying Posts
                              Posts()
                          }
                      }
                  }
                  
                  .padding(15)
              }
              //Scroll To Refresh
              .refreshable {
                  //Disabling Refresh For UID Based Posts
                  guard !basedOnUID else{return}
                  isFetching = true
                  posts = []
                  
                  //Resetting Pagination Document
                  paginationDoc = nil
                  await fetchPosts()
              }
              //Fetching For One Time
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
            let fetchedPosts = docs.documents.compactMap{ doc -> Post? in
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

struct ReusablePostsViews_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
