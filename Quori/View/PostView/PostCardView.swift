//
//  PostCardView.swift
//  Quori
//
//  Created by Bryan Danquah on 21/05/2023.
//

import SwiftUI

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseStorage

struct PostCardView: View {
    @State private var sharingContent: String = "Check out this amazing content!"
    
    @State var isZoomed = false
    @State var offset = CGSize.zero
    
    @State var messageText: String = ""
    @FocusState private var showKeyboard: Bool
    
    var post: Post
    
    @State var checkmark = false
    
    @State private var particles: [Particle] = []
    
    
    @State private var showingSheet = false
    // CallBacks
    var onUpdate: (Post) -> ()
    var onDelete: () -> ()
    
    //View Properties
    @AppStorage("user_uid") private var userUID: String = ""
    
    //For Live Updates
    @State private var docListener: ListenerRegistration?
    
    var body: some View {
        HStack(alignment: .top, spacing: 12){

                WebImage(url: post.userProfileURL)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 35, height: 35)
                    .clipShape(Circle())
                
              
            
            VStack(alignment: .leading, spacing: 6){
                if post.userName == "UCC SRC PRO"{
                    HStack{
                        Text(post.userName)
                            .font(.callout)
                            .foregroundColor(Color.gray)
                        
                        Image(systemName: "checkmark.seal.fill")
                            .font(.caption)
                            .foregroundColor(Color.yellow)
                    }
                }else{
                    Text(post.userName)
                        .font(.callout)
                        .foregroundColor(Color.gray)
                }
                
                Text(post.publishedDate.formatted(date: .numeric, time: .shortened))
                    .font(.caption2)
                    .foregroundColor(Color.gray)
                
                Text(post.text)
                    .textSelection(.enabled)
                    .padding(.vertical, 8)
                
                //Posting Image If Any
                if let postImageURL = post.imageURL{
                    GeometryReader{
                        let size = $0.size
                        WebImage(url: postImageURL)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                    .frame(height: 200)
                    .onTapGesture {
                        //self.isZoomed.toggle()
                        showingSheet.toggle()
                    }
                    .sheet(isPresented: $showingSheet) {
                     
                                NavigationView {
                                    ZStack{
                                        BlurView(style: .systemThinMaterialLight)
                                            //.cornerRadius(20)
                                            .toolbar(content: {
                                                
                                                
                                                ToolbarItem(placement: .navigationBarTrailing){
                                                    Menu{
                                                        Button("Share", role: .destructive, action: deletePost)
                                                        } label: {
                                                            Image(systemName: "ellipsis")
                                                                .font(.caption)
                                                                .rotationEffect(.init(degrees: -180))
                                                                .foregroundColor(.
                                                                                 black)
                                                                //.padding(8)
                                                                .contentShape(Rectangle())
                                                        }
                                                        
                                                        .frame(width: 60, height: 5)
                                                        
                                                        //.padding(.top, 80)
                                                }
                                            })
                                        WebImage(url: postImageURL)
                                            .resizable()
                                            .scaledToFit()
                                            .offset(y: offset.height)
                                        //.animation(.interactiveSpring())
                         
                                    }
                                    .ignoresSafeArea()
                                }
                                
                         
                        
                    }
                }
                PostInteraction()
            }
            
        }
        .hAlign(.leading)
        .overlay(alignment: .topTrailing, content: {
            //If Author of the Post, Display Delete Button
            if post.userUID == userUID{
                Menu{
                    Button("Delete Post", role: .destructive, action: deletePost)
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.caption)
                            .rotationEffect(.init(degrees: -90))
                            .foregroundColor(.
                                             black)
                            .padding(8)
                            .contentShape(Rectangle())
                    }
                    .offset(x: 8)
            }
        })
        .onAppear{
            //Adding Once Only
            if docListener == nil{
                guard let postID = post.id else {return}
                docListener = Firestore.firestore().collection("Posts").document(postID).addSnapshotListener({ snapshot,
                    error in
                    if let snapshot{
                        if snapshot.exists{
                            //Fetching Updated Document
                            if let updatedPost = try? snapshot.data(as: Post.self){
                                onUpdate(updatedPost)
                            }
                            }else{
                                //Document Deleted
                                onDelete()
                        }
                    }
                })
            }
        }
        .onDisappear{
            if let docListener{
                docListener.remove()
                self.docListener = nil
            }
        }
    }
    
    //Like and Dislike
    @ViewBuilder
    func PostInteraction()-> some View{
        VStack(alignment: .leading, spacing: -5) {
            HStack(spacing: 10){
                    Button(action: likePost){
                        Image(systemName: post.likedIDs.contains(userUID) ? "heart.fill" : "heart")
                            .font(.system(size: 25))
                            .foregroundColor(post.likedIDs.contains(userUID) ? Color("Vermilion"): Color.gray)
                    }
                    .overlay(alignment: .top){
                        ZStack{
                            ForEach(particles){particle in
                                Image(systemName: "heart.fill")
                                    .foregroundColor(post.likedIDs.contains(userUID) ? Color("Vermilion"): Color.gray)
                                    .scaleEffect(particle.scale)
                                    .offset(x: particle.randomX, y: particle.randomY)
                                    .opacity(particle.opacity)
                                    .opacity(post.likedIDs.contains(userUID) ? 1 : 0)
                                    .animation(.none, value: post.likedIDs.contains(userUID))
                            }
                        }
                        .onAppear{
                            if particles.isEmpty{
                                for _ in 1...15 {
                                    let particle = Particle()
                                    particles.append(particle)
                                }
                            }
                        }
                        .onChange(of: post.likedIDs.contains(userUID)){newValue in
                            if !newValue{
                                //Reset Animation
                                for index in particles.indices{
                                    particles[index].reset()
                                }
                            }else{
                                //Activate Particles
                                for index in particles.indices{
                                    let total: CGFloat = CGFloat(particles.count)
                                    let progress: CGFloat = CGFloat(index) / total
                                    
                                    let maxX: CGFloat = (progress > 0.5) ? 100 : -100
                                    let maxY: CGFloat = 60
                                    
                                    let randomX: CGFloat = ((progress > 0.5 ? progress - 0.5 : progress) * maxX)
                                    let randomY: CGFloat = ((progress > 0.5 ? progress - 0.5 : progress) * maxY) + 35
                                    
                                    let randomScale: CGFloat = .random(in: 0.35...1)
                                    
                                    withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)){
                                        let extraRandomX: CGFloat = (progress < 0.5 ? .random(in: 0...10) : .random(in: -10...0))
                                        let extraRandomY: CGFloat = .random(in: 0...30)
                                        particles[index].randomX = randomX + extraRandomX
                                        particles[index].randomY = -randomY - extraRandomY
                                    }
                                    withAnimation(.easeOut(duration: 0.3)) {
                                        particles[index].scale = randomScale
                                    }
                                    
                                    withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7).delay(0.25 + (Double(index) * 0.005))){
                                        particles[index].scale = 0.001
                                    }
                                }
                            }
                        }
                    }
                    

                    Button(action: dislikePost){
                        Image(systemName: post.dislikedIDs.contains(userUID) ? "heart.slash.fill" : "heart.slash")
                            .font(.system(size: 25))
                            .foregroundColor(post.dislikedIDs.contains(userUID) ? Color.black : Color.gray)
                    }
                   
                    Spacer()
                
                    Button(action: shareContent){
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 25))
                            .foregroundColor(Color.gray)
                    }
                   
  
            }
            .foregroundColor(Color.black)
            .padding(.vertical, 8)
            
            if post.likedIDs.count > 1{
                Text("\(post.likedIDs.count) likes")
                    .font(.caption.bold())
                    .foregroundColor(Color.black)
            }else if post.likedIDs.count < 1 {
                Text("\(post.likedIDs.count) likes")
                    .font(.caption.bold())
                    .foregroundColor(Color.black)
            }else {
                Text("\(post.likedIDs.count) like")
                    .font(.caption.bold())
                    .foregroundColor(Color.black)
            }
            
        }
    }
    
    //Liking Post
    func likePost(){
        Task{
            guard let postID = post.id else{return}
            if post.likedIDs.contains(userUID){
                //Removing User ID From The Array
                try await Firestore.firestore().collection("Posts").document(postID).updateData([
                    "likedIDs": FieldValue.arrayRemove([userUID])
                ])
            }else{
                //Adding User ID To Liked Array and Removing ID From Dislike Array (If Added previously)
                try await Firestore.firestore().collection("Posts").document(postID).updateData([
                    "likedIDs": FieldValue.arrayUnion([userUID]),
                    "dislikedIDs": FieldValue.arrayRemove([userUID])
                ])
            }
        }
    }
    
    //Dislike Post
    func dislikePost(){
        Task{
            guard let postID = post.id else{return}
            if post.dislikedIDs.contains(userUID){
                //Removing User ID From The Array
                try await Firestore.firestore().collection("Posts").document(postID).updateData([
                    "dislikedIDs": FieldValue.arrayRemove([userUID])
                ])
            }else{
                //Adding User ID To Liked Array and Removing ID From Dislike Array (If Added previously)
                try await Firestore.firestore().collection("Posts").document(postID).updateData([
                    "likedIDs": FieldValue.arrayRemove([userUID]),
                    "dislikedIDs": FieldValue.arrayUnion([userUID])
                ])
            }
        }
    }
    
    //Delete Post If Author
    func deletePost(){
        Task{
            do{
                //Delete Profile Image From Firebase Storage
                if post.imageReferenceID != ""{
                    try await Storage.storage().reference().child("Post_Images").child(post.imageReferenceID).delete()
                }
                
                //Delete Firesrore Document
                guard let postID = post.id else{return}
                try await Firestore.firestore().collection("Posts").document(postID).delete()
            }catch{
                print(error.localizedDescription)
            }
        }
    }
    
//Custom Like Button
    @ViewBuilder
    func CustomButton(systemImage: String, font: Font, status: Bool, activeTint: Color, inActiveTint: Color, onTap: @escaping() -> ()) -> some View{
        Button(action: likePost){
            Image(systemName: systemImage)
                .font(.title3)
                .particleEffect(systemImage: systemImage, font: .title3, status: status, activeTint: activeTint, inActiveTint: inActiveTint)
                .foregroundColor(status ? activeTint : inActiveTint)
        }
    }
    
    func shareContent() {
        let activityViewController = UIActivityViewController(activityItems: [post.userName, post.text], applicationActivities: nil)
          UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
      }
}

//Blurred View
struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(
            effect: UIBlurEffect(style: style)
        )
        return view
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        //do nothing
    }
}
