//
//  MainScreen.swift
//  Quori
//
//  Created by Bryan Danquah on 25/05/2023.
//

import SwiftUI

struct MainScreen: View {
    //View Porperties
    
    @State private var activateTag: String = "SRC"
    @State private var carousel: Bool = false
    @Namespace private var animation
    @State private var showDetailView: Bool = false
    @State private var selectedBook: Book?
    @State private var animateCurrentBook: Bool = false
    
    @Binding var showCandidateView: Bool
    
    @State private var Loading: Bool = false
    
    var body: some View {
        VStack(spacing: 15){
            Button(action:{
                //close view
               showCandidateView = false
            }) {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.black)
                    .contentShape(Rectangle())
            }
            .unredacted()
            .padding([.leading, .vertical], 15)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack{
                Text("Browse")
                    .font(.largeTitle.bold())
                    .unredacted()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 15)
            
            TagsView()
                .unredacted()
                .disabled(Loading ? true : false)
            
            GeometryReader{
                let size = $0.size
                ScrollView(.vertical, showsIndicators: false){
                    VStack(spacing: 35){
                        ForEach(sample){ book in
                            BookCardView(book)
                            //Opening DetailView onTap
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.2)){
                                        animateCurrentBook = false
                                        selectedBook = book
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15){
                                        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)){
                                            showDetailView = true
                                        }
                                    }
                                }
                                .disabled(Loading ? true : false)
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 20)
                    .padding(.bottom, bottomPadding(size))
                    .background{
                        ScrollViewDetector(carousel: $carousel, totalCardCount: sample.count)
                    }
                }
                .coordinateSpace(name: "SCROLLVIEW")
            }
            .padding(.top, 15)
        }
        .redacted(reason: Loading ? .placeholder : [])
        .onAppear{NetworkCall()}
        .overlay{
            if let selectedBook, showDetailView{
                DetailView(show: $showDetailView, animation: animation, book: selectedBook)
                    .transition(.asymmetric(insertion: .identity, removal: .offset(y: 5)))
            }
        }
        .onChange(of: showDetailView){ newValue in
            //Reset Book Animation
            if !newValue {
                //Reset Book Animation
                withAnimation(.easeInOut(duration: 0.15).delay(0.4)){
                    animateCurrentBook = false
                }
            }
        }
    }
    func bottomPadding(_ size: CGSize = .zero) -> CGFloat{
        let cardHeight: CGFloat = 220
        let scrollHeight: CGFloat = size.height
        
        return scrollHeight - cardHeight - 40
    }
    
    @ViewBuilder
    func BookCardView(_ book: Book) -> some View {
        GeometryReader{
            let size = $0.size
            let rect = $0.frame(in: .named("SCROLLVIEW"))
            
            //Rotation Effect
            //let minY = rect.minY
            
            HStack(spacing: -20){
                VStack(alignment: .leading, spacing: 6){
                    Text(book.title)
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    Text("\(book.authur)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    RatingView(rating: book.rating)
                    
                    Spacer(minLength: 10)
                    
                    HStack(spacing: 4){
                        Text("\(book.bookView)")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.blue)
                        
                        Text("Views")
                            .font(.caption)
                            .foregroundColor(Color.gray)
                        
                        Spacer(minLength: 0)
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundColor(Color.gray)
                            .unredacted()
                            .disabled(Loading ? true : false)
                    }
                }
                .padding(20)
                .frame(width: size.width / 2, height: size.height * 0.8)
                .background{
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.white)
                        .shadow(color: .black.opacity(0.08), radius: 8, x: 5, y: 5)
                        .shadow(color: .black.opacity(0.08), radius: 8, x: -5, y: -5)
                }
                //Putting card above book image
                .zIndex(1)
               
                
                ZStack{
                    if !(showDetailView && selectedBook?.id == book.id){
                        Image(book.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width / 2, height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        //Matched Geeometry
                            .matchedGeometryEffect(id: book.id, in: animation)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: -5)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(width: size.width)
            //3D Rotation
            .rotation3DEffect(.init(degrees: convertOffsetToRotation(rect)), axis: (x: 1, y: 0, z: 0), anchor: .bottom, anchorZ: 1, perspective: 0.8)
        }
        .frame(height: 220)
    }
    
    //Simulate Network Call
    func NetworkCall(){
        Loading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            Loading = false
        }
    }
    
    //Function to convert MinY to Rotation
    func convertOffsetToRotation(_ rect: CGRect) -> CGFloat {
        let cardHeight = rect.height + 20
        let minY = rect.minY - 20
        let progress = minY < 0 ? (minY / cardHeight) : 0
        let constraineProgress = min(-progress, 1.0)
        return constraineProgress * 90
    }
    
    @ViewBuilder
    func TagsView() -> some View{
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 10){
                ForEach(tags, id: \.self){ tag in
                    Text(tag)
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background{
                            if activateTag == tag {
                                Capsule()
                                     .fill(.blue)
                                     .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                            }
                            else {
                               Capsule()
                                    .fill(.gray.opacity(0.2))
                            }
                        }
                        .foregroundColor(activateTag == tag ? Color.white : Color.gray)
                        .onTapGesture {
                            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.7)) {
                                activateTag = tag
                            }
                        }
                }
            }
            .padding(.horizontal, 15)
        }
    }
}

//Sample Tags
var tags: [String] = [
    "SRC","Oguaa Hall", "Atlantic Hall", "Adehye Hall", "Casley Hayford Hall", "Valco Hall", "Kwame Nkrumah Hall", "SRC Hall"
]
struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


