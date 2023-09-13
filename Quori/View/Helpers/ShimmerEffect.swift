//
//  ShimmerEffect.swift
//  Quori
//
//  Created by Bryan Danquah on 10/06/2023.
//

import SwiftUI

//Custom View Modifier
extension View{
    @ViewBuilder
    func shimmer(_ config: ShimmerConfig) -> some View{
        self
            .modifier(ShimmerEffectHelper(config: config))
    }
}
    //Effect Helper
    fileprivate struct ShimmerEffectHelper: ViewModifier{
        //Shimmer Config
        var config: ShimmerConfig
        
        //Animation Properties
        @State private var moveTo: CGFloat = -0.7
        func body(content: Content) -> some View {
            content
                .hidden()
                .overlay{
                    Rectangle()
                        .fill(config.tint)
                        .mask{
                            content
                        }
                        .overlay{
                            //Shimmer
                            GeometryReader{
                                let size = $0.size
                                let extraOffset = size.height / 2.5
                                Rectangle()
                                    .fill(config.highlight)
                                    .mask{
                                        Rectangle()
                                            .fill(
                                                .linearGradient(colors: [Color.white.opacity(0), config.highlight.opacity(config.highlightOpacity)], startPoint: .top, endPoint: .bottom)
                                            )
                                        //Blur
                                            .blur(radius: config.blur)
                                            .rotationEffect(.init(degrees: -70))
                                            .offset(x: moveTo > 0 ? extraOffset : -extraOffset)
                                            .offset(x: size.width * moveTo)
                                    }
                            }
                            .mask{
                                content
                            }
                        }
                    //Movement Animation
                        .onAppear{
                            DispatchQueue.main.async {
                                moveTo = 0.7
                            }
                        }
                        .animation(.linear(duration: config.speed).repeatForever(autoreverses: false), value: moveTo)
                }
        }
    }
    
    //Shimmer Config
    struct ShimmerConfig {
        var tint: Color
        var highlight: Color
        var blur: CGFloat = 0
        var highlightOpacity: CGFloat = 1
        var speed: CGFloat = 2
    }
struct ShimmerEffect_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
