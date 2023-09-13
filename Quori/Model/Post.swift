//
//  Post.swift
//  Quori
//
//  Created by Bryan Danquah on 21/05/2023.
//

import SwiftUI
import FirebaseFirestoreSwift

//Post Model
struct Post: Identifiable,Codable,Equatable,Hashable{
    @DocumentID var id: String?
    var text: String
    var imageURL: URL?
    var imageReferenceID: String = ""
    var publishedDate: Date = Date()
    var likedIDs: [String] = []
    var dislikedIDs: [String] = []
//var commentTextIDs: String = ""
    
    //Basic User Info
    var userName: String
    var userUID: String
    var userProfileURL: URL
    
    
    enum CodingKeys: CodingKey{
        case id
        case text
        case imageURL
        case imageReferenceID
        case publishedDate
        case likedIDs
        case dislikedIDs
       // case commentTextIDs
        case userName
        case userUID
        case userProfileURL
    }

}

