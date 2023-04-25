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
    let isCorrect: Bool
    let completion: () -> Void

    init(text: String, isCorrect: Bool, completion: @escaping () -> Void) {
        self.text = text
        self.isCorrect = isCorrect
        self.completion = completion
    }

    func beginAnimation() {
        isAnimating = true
        offset = isCorrect ? -150 : 150
        animationLength = isCorrect ? 3.0 : 1.5

        DispatchQueue.main.asyncAfter(deadline: .now() + animationLength / 2) { [weak self] in
            guard let self else { return }
            self.offset = self.offset > 0 ? 100 : -100
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

        var endingOffset: CGFloat {
            switch self {
            case .correct:
                return 3.0
            case .incorrect:
                return 1.5
            }
        }

        var length: TimeInterval {
            switch self {
            case .correct:
                return -100
            case .incorrect:
                return 100
            }
        }
    }
}
