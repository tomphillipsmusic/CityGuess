//
//  FlippableContent.swift
//  CityGuess
//
//  Created by Tom Phillips on 7/26/23.
//

import SwiftUI

struct FlippableContent<Front: View, Back: View>: View {
    @State private var degrees: Double = 0
    let front: () -> Front
    let back: () -> Back
    
    var body: some View {
        VStack {
            Group {
                if degrees == 0 {
                    front()
                } else {
                    back()
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                }
                
            }
            .rotation3DEffect(.degrees(degrees), axis: (x: 0, y: 1, z: 0))
            .onTapGesture {
                withAnimation {
                    degrees = degrees == 0 ? 180 : 0
                }
            }
        }
    }
}

struct FlippableContent_Previews: PreviewProvider {
    static var previews: some View {
        FlippableContent {
            Color.blue
        } back: {
            Color.green
        }
        
    }
}
