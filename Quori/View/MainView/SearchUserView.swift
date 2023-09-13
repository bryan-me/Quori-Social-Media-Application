//
//  SearchUserView.swift
//  Quori
//
//  Created by Bryan Danquah on 21/05/2023.
//

import SwiftUI
import FirebaseFirestore

struct SearchUserView: View {
    //View Properties
    @State private var fetchedUsers: [User] = []
    @State private var searchText: String = ""
    @Environment(\.dismiss) private var dismiss
    var body: some View {

            List{
                    ForEach(fetchedUsers){ user in
                        NavigationLink{
                            ReusableProfileContent(user: user)
                        }label: {
                            if user.userEmail.contains("@stu.edu.gh.com"){
                                HStack{
                                    Text(user.username)
                                        .font(.callout)
                                        
                                    
                                    Image(systemName: "checkmark.seal.fill")
                                        .font(.callout)
                                        .foregroundColor(Color.blue)
                                }
                                .hAlign(.leading)
                            }else{
                                Text(user.username)
                                    .font(.callout)
                                    .hAlign(.leading)
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Search User")
                .searchable(text: $searchText)
                .onSubmit (of: .search, {
                    //Searching User From Firebase Firestore
                    Task{await searchUsers()}
                })
                .onChange(of: searchText, perform: { newValue in
                    if newValue.isEmpty{
                        fetchedUsers = []
                    }
            })
 
    }
    //Func To Search For Users
    func searchUsers()async{
        do{
            let documents = try await Firestore.firestore().collection("Users")
                .whereField("username", isGreaterThanOrEqualTo: searchText)
                .whereField("username", isLessThanOrEqualTo: "\(searchText)\u{f8ff}")
                .getDocuments()
            
            let users = try documents.documents.compactMap { doc -> User? in
                try doc.data(as: User.self)
            }
            
            //Update UI on Main thread
            await MainActor.run(body: {
                fetchedUsers = users
            })
        }catch{
            print(error.localizedDescription)
        }
    }
}

struct SearchUserView_Previews: PreviewProvider {
    static var previews: some View {
        SearchUserView()
    }
}
