//
//  AdminContact.swift
//  Quori
//
//  Created by Bryan Danquah on 21/05/2023.
//

import SwiftUI

struct AdminContact: View {
    var imageURL = URL(string: "https://ucc.edu.gh/sites/default/files/ucc-logo.webp")
    let phoneNumber1 = "+233 [03321]32440"
    let phoneNumber2 = "+233 [03321] 32480-9"
    var body: some View {
        VStack {
            NavigationView{
                VStack {
                    VStack{
                        ScrollView(.vertical){
                            NavigationLink(destination: AdminChat()) {
                                VStack {
                                    Divider()
                                        .foregroundColor(Color.black)
                                    HStack{
                                        AsyncImage(url: imageURL){ image in
                                            image.resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 50, height: 50)
                                                .cornerRadius(50)
                                        }placeholder: {
                                            ProgressView()
                                        }
                                            VStack(alignment: .leading){
                                                Text("Admin")
                                                    .foregroundColor(Color.black)
                                                    .font(.title).bold()
                                                
                                                Text("Chat Administrator...")
                                                    .font(.caption)
                                                    .foregroundColor(Color.gray)
                                            }
                                            Spacer(minLength: 10)
                                            
                                            VStack(alignment: .trailing, spacing: 10){
                                                Text("\(Date().formatted(.dateTime.day().month()))")
                                                    .font(.caption)
                                                    .foregroundColor(Color.gray)
                                                
                                                Image(systemName: "pin.fill")
                                                    .foregroundColor(Color.gray)
                                                    .rotationEffect(.init(degrees: 45))
                                            }
                                    }
                                    Divider()
                                        .foregroundColor(Color.black)
                                        .padding(.bottom, 50)
                                    
                                    
                                    
                                }
                            }
                            
                        }
                        
                    }
                    
                    .padding()
                    
                .navigationTitle("Help")
                    
                    VStack(alignment: .leading){
                        Text("Contact Info")
                            .foregroundColor(Color.black)
                            .font(.title).bold()
                            .padding(.bottom)
                        VStack(alignment: .leading){
                            Text("The Registrar, University of Cape Coast, Cape Coast, Ghana.")
                                .font(.callout)
                                .foregroundColor(Color.gray)
                            
                            Text("\n\(phoneNumber1),\n\(phoneNumber2)")
                            
                            Text("\nregistrar@ucc.edu.gh")
                        }
                    }
                    .padding(.bottom, 50)
                }
                
            }
            
            
        }
        .padding(.top, -50)
    }
}

struct AdminContact_Previews: PreviewProvider {
    static var previews: some View {
        AdminContact()
    }
}
