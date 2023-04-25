//
//  VerticalTextAnimationViewModel.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/25/23.
//

import SwiftUI

class VerticalTextAnimationViewModel: ViewModel {

    @Published var animationLength: TimeInterval = 1.5
    @Published var isAnimating = true
    @Published var offset: CGFloat = 0
    @Published var opacity: CGFloat = 1

    let text: String
    let animation: Animation
    let completion: () -> Void

    init(text: String, isCorrect: Bool, completion: @escaping () -> Void) {
        self.text = text
        self.animation = isCorrect ? .correct : .incorrect
        self.completion = completion
    }

    func beginAnimation() {
        isAnimating = true
        offset = animation.initialOffset

        DispatchQueue.main.asyncAfter(deadline: .now() + animation.length / 2) { [weak self] in
            guard let self else { return }
            self.offset = self.animation.endingOffset
            self.opacity = 0
            self.isAnimating = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + (animationLength + 1.0)) { [weak self] in
            guard let self else { return }
            self.completion()
        }
    }

    enum Animation {
        case correct, incorrect

        var initialOffset: CGFloat {
            switch self {
            case .correct:
                return -150
            case .incorrect:
                return 150
            }
        }

        var endingOffset: TimeInterval {
            switch self {
            case .correct:
                return -100
            case .incorrect:
                return 100
            }
        }

        var length: CGFloat {
            switch self {
            case .correct:
                return 3.0
            case .incorrect:
                return 1.5
            }
        }
    }
}
