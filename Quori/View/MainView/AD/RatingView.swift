//
//  RatingView.swift
//  Quori
//
//  Created by Bryan Danquah on 25/05/2023.
//

import SwiftUI

struct RatingView: View {
    var rating: Int
    var body: some View {
        HStack(spacing: 4){
            ForEach(1...5, id: \.self){ index in
                Image(systemName: "star.fill")
                    .font(.caption2)
                    .foregroundColor(index <= rating ? Color.yellow : Color.gray.opacity(0.5))
            }
            
            Text("(\(rating))")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(Color.yellow)
                .padding(.leading, 5)
        }
    }
}
