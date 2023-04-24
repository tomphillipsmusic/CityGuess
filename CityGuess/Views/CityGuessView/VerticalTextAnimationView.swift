//
//  VerticalTextAnimationView.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/21/23.
//

import SwiftUI

struct VerticalTextAnimationView: View {
    let text: String
    @Binding var isShowing: Bool
    @State private var isAnimating = true
    @State private var offset: CGFloat = -100
    @State private var opacity: CGFloat = 1

    var body: some View {
        Text(text)
            .padding()
            .background(RoundedRectangle(cornerRadius: 10.0).foregroundColor(Color("Background")))
            .font(.largeTitle)
            .opacity(opacity)
            .offset(y: offset)
            .animation(.easeInOut(duration: 1.5), value: offset)
            .animation(.easeInOut(duration: 1.5), value: isAnimating)

            .onAppear {
                self.isAnimating = true
                offset = 100

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    offset = -100
                    opacity = 0
                    isAnimating = false

                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                     isShowing = false
                }
            }
    }
}

struct VerticalTextAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        VerticalTextAnimationView(text: "Hello World ", isShowing: .constant(true))
    }
}

extension View {
    func animate(duration: CGFloat, _ execute: @escaping () -> Void) async {
        await withCheckedContinuation { continuation in
            withAnimation(.linear(duration: duration)) {
                execute()
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                continuation.resume()
            }
        }
    }
}
