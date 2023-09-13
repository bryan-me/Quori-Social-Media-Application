//
//  ReusableButton.swift
//  Quori
//
//  Created by Bryan Danquah on 21/05/2023.
//

import SwiftUI

struct ReusableButton: View {
    @State private var createNewPost: Bool = false
    //var recentPosts: [Post] = []
    let email: String = "@stu.edu.gh.com"
    var user: User
    
    var body: some View {
        HStack{
            if user.userEmail.contains(email){
                Button{
                    createNewPost.toggle()
                }label: {
                    Image(systemName: "plus.rectangle.fill.on.rectangle.fill")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                        .padding(13)
                        .background(.blue, in: Circle())
                }
                .padding(15)
            }
            
        }
        }
}
struct ReusableButton_Previews: PreviewProvider {
    static var previews: some View {
        ReusableButton(user: User(username: "", userBio: "", userBioLink: "", userUID: "", userEmail: "", userProfileURL: URL(string: "")!))
    }
}


