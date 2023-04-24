//
//  FloatingAnimationView.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/21/23.
//

import SwiftUI

struct FloatingAnimationView: View {
    @Binding var isShowing: Bool
    let isCorrect: Bool
    let correctAnswer: String

    var body: some View {
        ZStack {
            LottieView(animationName: isCorrect ? "correct" : "incorrect")
            VerticalTextAnimationView(text: correctAnswer, isCorrect: isCorrect, isShowing: $isShowing)
        }
    }
}
struct FloatingAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        FloatingAnimationView(isShowing: .constant(true), isCorrect: true, correctAnswer: "New York")
    }
}
