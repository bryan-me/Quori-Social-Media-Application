//
//  Model.swift
//  Quori
//
//  Created by Bryan Danquah on 25/05/2023.
//

import SwiftUI

//Book Model
struct Book: Identifiable, Hashable{
    var id: String = UUID().uuidString
    var title: String
    var imageName: String
    var authur: String
    var rating: Int
    var bookView: Int
}

var sample: [Book] = [
    .init(title: "Team Dependable", imageName: "Candidate 1", authur: "Emmanuel Obuor & Agartha Aduse-Poku", rating: 4, bookView: 1023),
    .init(title: "The Governor", imageName: "Candidate 2", authur: "Desmond Eshun", rating: 5, bookView: 1023),
    .init(title: "Team JAK", imageName: "Candidate 3", authur: "Johua Addai Kwaku & Magdamene Attah Bakobie", rating: 3, bookView: 1023),
    .init(title: "Esty", imageName: "Candidate 4", authur: "Esther Acquah Benson", rating: 4, bookView: 1023),
    .init(title: "Team Mykel", imageName: "Candidate 5", authur: "Michael Dzidzornu Kpatsa & Gifty Agyeiwaa Assan", rating: 5, bookView: 1023)
]

