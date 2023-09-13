//
//  TitleRow.swift
//  Quori
//
//  Created by Bryan Danquah on 21/05/2023.
//

import SwiftUI

struct TitleRow: View {
    let phoneNumber = "0242943222"
    var imageURL = URL(string: "https://ucc.edu.gh/sites/default/files/ucc-logo.webp")
    var name = "Admin"
    var body: some View {
        HStack(spacing: 20){
            
            AsyncImage(url: imageURL){ image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .cornerRadius(50)
            }placeholder: {
                ProgressView()
            }
            VStack(alignment: .center){
                Text(name)
                    .font(.title.bold())
                    .foregroundColor(Color("White"))
                
                Text("active")
                    .font(.caption)
                    .foregroundColor(Color("White"))
            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            Button{
                makePhoneCall()
            }label: {
                Image(systemName: "phone.fill")
                    .foregroundColor(Color.gray)
                    .padding(10)
                    .background{
                        Circle()
                            .foregroundColor(Color.white)
                    }
            }
        }
        .padding()
    }
    func makePhoneCall() {
          if let phoneURL = URL(string: "tel://\(phoneNumber)"),
             UIApplication.shared.canOpenURL(phoneURL) {
              UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
          }
      }
}

struct TitleRow_Previews: PreviewProvider {
    static var previews: some View {
        TitleRow()
            .background(Color("White"))
    }
}

