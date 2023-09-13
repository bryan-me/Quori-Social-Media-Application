//
//  ParticleEffect.swift
//  Quori
//
//  Created by Bryan Danquah on 21/05/2023.
//

import SwiftUI

extension View{
    @ViewBuilder
    func particleEffect(systemImage: String, font: Font, status: Bool, activeTint: Color, inActiveTint: Color)-> some View{
        self
        .modifier(
            ParticleModifier(systemImage: systemImage, font: font, status: status, activeTint: activeTint, inActiveTint: inActiveTint)
        )
    }
}

fileprivate struct ParticleModifier: ViewModifier{
    var systemImage: String
    var font: Font
    var status: Bool
    var activeTint: Color
    var inActiveTint: Color
    
    @State private var particles: [Particle] = []
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top){
                ZStack{
                    ForEach(particles){particle in
                        Image(systemName: systemImage)
                            .foregroundColor(status ? activeTint : inActiveTint)
                            .scaleEffect(particle.scale)
                            .offset(x: particle.randomX, y: particle.randomY)
                            .opacity(particle.opacity)
                            .opacity(status ? 1 : 0)
                            .animation(.none, value: status)
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
                .onChange(of: status){newValue in
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
    }
}
struct MyPreviewProvider_Previews: PreviewProvider{
    static var previews: some View{
        ContentView()
    }
}
