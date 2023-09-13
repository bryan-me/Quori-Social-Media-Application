//
//  MainView.swift
//  Quori
//
//  Created by Bryan Danquah on 21/05/2023.
//

import SwiftUI

struct MainView: View {

    var body: some View {
        
        //Tab View with Recent Posts and Profile Tabs
        TabView{
            PostsView()
                .tabItem{
                    Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled")
                    Text("Feed")
                }
            
            
            EventView()
                .tabItem{
                    Image(systemName: "calendar")
                    Text("Task")
                }
            

            ArtificialIntelligence()
                .tabItem{
                    Image(systemName: "xbox.logo")
                    Text("Snr Lecturer")
                }
            
            AdminContact()
                .tabItem{
                    Image(systemName: "person.2.badge.gearshape.fill")
                    Text("Help")
                }
            
           // ProfileView()
             //   .tabItem{
               //     Image(systemName: "person.crop.circle")
                 //   Text("Profile")
                //}
        }
        //Changing Tab Label Tint To Black
        .tint(Color("Cobalt"))
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
