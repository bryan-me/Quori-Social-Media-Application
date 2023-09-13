//
//  Extensions.swift
//  Quori
//
//  Created by Bryan Danquah on 21/05/2023.
//

import Foundation
import SwiftUI

//Adding rounded corners to an object
extension View{
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner)-> some View{
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
struct RoundedCorner: Shape{
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
