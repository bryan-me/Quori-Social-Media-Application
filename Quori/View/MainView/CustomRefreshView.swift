//
//  CustomRefreshView.swift
//  BookAppUI
//
//  Created by Bryan Danquah on 23/05/2023.
//

import SwiftUI


struct CustomRefreshView<Content: View>: View {
    var content: Content
    var showsIndicator: Bool

    // MARK: Async Call Back
    var onRefresh: ()async->()
    init(showsIndicator: Bool = false, @ViewBuilder content:
        @escaping ()->Content, onRefresh: @escaping () async-> ()){
        self.showsIndicator = showsIndicator
        self.content = content()
        self.onRefresh = onRefresh
    }
    
    @StateObject var scrollDelegate: ScrollViewModel = .init()
    var body: some View{
        ScrollView(.vertical, showsIndicators: showsIndicator){
            VStack (spacing: 0){
                //Arrow and Text
                //From Dynamic Island
                Rectangle()
                    .fill(.clear)
                    .frame(height: 150 * scrollDelegate.progress)
                
                content
            }
            .offset(coordinateSpace: "SCROLL") { offset in
                //Store Content Offset
                scrollDelegate.contentOffset = offset
                
                //Stopping Progress when Eligible for refresh
                if !scrollDelegate.isEligible{
                    var progress = offset / 150
                    progress = ( progress < 0 ? 0 : progress)
                    progress = ( progress > 1 ? 1 : progress)
                    
                    scrollDelegate.scrollOffset = offset
                    scrollDelegate.progress = progress
                }
                
                if scrollDelegate.isEligible && !scrollDelegate.isRefreshing{
                    scrollDelegate.isRefreshing = true
                    //Haptic Feedback
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
            }
        }
        .overlay(alignment: .top, content: {
            ZStack{
                Capsule()
                    .fill(.clear)
            }
            .frame(width: 126, height: 37)
            .offset(y: 11)
            .frame(maxHeight: .infinity, alignment: .top)
            .overlay(alignment: .top, content: {
                Canvas { context, size in
                    context.addFilter(.alphaThreshold(min: 0.5, color: .black))
                    context.addFilter(.blur(radius: 10))
                    
                    //Drawing inside new layer
                    context.drawLayer{ ctx in
                        for index in [1,2]{
                            if let resolvedView = context.resolveSymbol(id: index){
                                ctx.draw(resolvedView, at: CGPoint(x: size.width / 2, y: 30))
                            }
                        }
                    }
                }symbols: {
                    CanvasSymbol()
                        .tag(1)
                    
                    CanvasSymbol(isCircle: true)
                        .tag(2)
                }
                .allowsHitTesting(false)
            })
            .overlay(alignment: .top, content: {
                RefreshView()
                    .offset(y: 11)
            })
            .ignoresSafeArea()
        })
            .coordinateSpace(name: "SCROLL")
            .onAppear(perform: scrollDelegate.addGesture)
            .onDisappear(perform: scrollDelegate.removeGesture)
            .onChange(of: scrollDelegate.isRefreshing){ newValue in
                //calling Async Method
                if newValue{
                    Task{
                        try? await Task.sleep(nanoseconds: 1_000_000_000)
                        await onRefresh()
                        //Reset Properties
                        withAnimation(.easeInOut(duration: 0.25)){
                            scrollDelegate.progress = 0
                            scrollDelegate.isEligible = false
                            scrollDelegate.isRefreshing = false
                            scrollDelegate.scrollOffset = 0
                        }
                    }
                }
            }
    }
    
    @ViewBuilder
    func CanvasSymbol(isCircle: Bool = false)->some View {
        if isCircle{
            let centerOffset = scrollDelegate.isEligible ?
            (scrollDelegate.contentOffset > 95 ? scrollDelegate.contentOffset :
            95) : scrollDelegate.scrollOffset
            
            //Applying Offset
            let offset = scrollDelegate.scrollOffset > 0 ? centerOffset : 0
            
            let scaling = ((scrollDelegate.progress / 1) * 0.21)
            Circle()
                .fill(.black)
                //change scalling here (37 / value)
                .frame(width: 47, height: 47)
                
                .scaleEffect(0.79 + scaling, anchor: .center)
                .offset(y: offset)
        }else{
            Capsule()
                .fill(.black)
                .frame(width: 126, height: 37)
        }
    }
    
    @ViewBuilder
    func RefreshView() -> some View{
        let centerOffset = scrollDelegate.isEligible ?
        (scrollDelegate.contentOffset > 95 ? scrollDelegate.contentOffset :
        95) : scrollDelegate.scrollOffset
        
        //Applying Offset
        let offset = scrollDelegate.scrollOffset > 0 ? centerOffset : 0
        
       
        ZStack{
            Image (systemName: "arrow.down")
                .font(.callout.bold())
                .foregroundColor (Color.white)
                .frame(width: 38, height: 38)
                .rotationEffect(.init(degrees: scrollDelegate.progress * 180))
                .opacity(scrollDelegate.isRefreshing ? 0 : 1)

            
            ProgressView()
                .tint(Color.white)
                .frame(width: 38, height: 38)
                .opacity(scrollDelegate.isRefreshing ? 1 : 0)
        }
            .animation(.easeInOut (duration: 0.25), value: scrollDelegate.isEligible)
            .opacity(scrollDelegate.progress)
            .offset(y: offset)
    }
}

struct CustomRefreshView_Previews: PreviewProvider {
    static var previews: some View {
        CustomRefreshView(showsIndicator: false){
            VStack {
                Rectangle()
                    .fill(.red)
                .frame(height: 200)
                
                Rectangle()
                    .fill(.yellow)
                    .frame(height: 200)
            }
        }onRefresh: {
            
        }
    }
}

//For Simultanous Pan Gesture
class ScrollViewModel: NSObject,ObservableObject,UIGestureRecognizerDelegate{
    //MARK: Properties
    @Published var isEligible: Bool = false
    @Published var isRefreshing: Bool = false
    
    //Offset and Progress
    @Published var scrollOffset: CGFloat = 0
    @Published var contentOffset: CGFloat = 0
    @Published var progress: CGFloat = 0
    //MARK: Since We need to Know when the user Left the Screen to Start Refresh
    // Adding Pan Gesture To UI Main Application Window
    // With Simultaneous Gesture Gesture
    //Thus it Wont disturb SwiftUI Scroll's And Gesture's
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer)
    -> Bool {
        return true
    }
        // MARK: Adding Gesture
        func addGesture(){
            let panGesture = UIPanGestureRecognizer(target: self, action:
                #selector(onGestureChange(gesture:)))
            panGesture.delegate = self
            
            rootController().view.addGestureRecognizer(panGesture)
        }
    
    //Removing when leaving the screen
    func removeGesture(){
        rootController().view.gestureRecognizers?.removeAll()
    }
        
        // MARK: Finding Root Controller
        func rootController()->UIViewController{
            guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene
            else{
                return .init()
            }
            guard let root = screen.windows.first?.rootViewController else{
                return .init()
            }
            return root
                }
        @objc
        func onGestureChange(gesture: UIPanGestureRecognizer) {
            if gesture.state == .cancelled || gesture.state == .ended{
                print("User Released Touch")
                
                //Max Duration Here
                if !isRefreshing{
                    if scrollOffset > 150{
                        isEligible = true
                    }else{
                        isEligible = false
                    }
                }
            }
        }
    }
//Offset Modidier
extension View{
    func offset(coordinateSpace: String, offset: @escaping(CGFloat)->())-> some View{
        self
            .overlay{
                GeometryReader{ proxy in
                    let minY = proxy.frame(in: .named(coordinateSpace)).minY
                    Color.clear
                        .preference(key: OffsetKey.self, value: minY)
                        .onPreferenceChange(OffsetKey.self){value in
                            offset(value)
                        }
                }
            }
    }
}

//Offset Preference Key
struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

