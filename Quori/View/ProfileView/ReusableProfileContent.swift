//
//  ReusableProfileContent.swift
//  Quori
//
//  Created by Bryan Danquah on 21/05/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct ReusableProfileContent: View {
    @State private var fetchedPosts: [Post] = []
    
    var user: User
    
    
    @State var emailText: String = ""
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            LazyVStack{
                HStack(spacing: 12){
                    WebImage(url: user.userProfileURL).placeholder{
                        
                        //Image Placeholder
                        Image(systemName: "person")
                            .resizable()
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 6){
                        if user.userEmail.contains("@stu.edu.gh.com"){
                            HStack{
                                Text(user.username)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.caption)
                                    .foregroundColor(Color.cyan)
                            }
                        }else{
                            Text(user.username)
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        
                        
                        Text(user.userBio)
                            .font(.caption)
                            .foregroundColor(Color.gray)
                            .lineLimit(3)
                        
                        Text(user.userEmail)
                            .font(.caption)
                            .foregroundColor(Color.gray)
                            .lineLimit(3)
                            .onAppear{
                                setEmailText()
                            }
                    
                        //Displaying Bio Link If Provided During SignUp
                        if let bioLink = URL(string: user.userBioLink){
                            Link(user.userBioLink, destination: bioLink)
                                .font(.callout)
                                .tint(Color.blue)
                                .lineLimit(1)
                        }
                    }
                    .hAlign(.leading)
                }
                
                Text("Posts")
                    .font((.title2))
                    .fontWeight(.semibold)
                    .foregroundColor(Color.black)
                    .hAlign(.leading)
                    .padding(.vertical, 15)
                
                ReusablePostsViews(basedOnUID: true, uid: user.userUID, posts: $fetchedPosts)
            }
            .padding(15)
        }
    }
    
    func emailContainsSubstring()-> Bool {
        return user.userEmail.contains("@stu.edu.gh.com")
    }
    
    func setEmailText() {
        if emailContainsSubstring() {
            emailText = user.userEmail
        } else {
            emailText = user.userEmail
        }
    }
    
}
 

