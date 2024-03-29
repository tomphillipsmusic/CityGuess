//
//  FloatingAnimationView.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/21/23.
//

import SwiftUI

struct FloatingAnimationView<ViewModel: CityGuessViewModel>: View {
    @Environment(\.accessibilityReduceMotion) var isMotionReduced
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        ZStack {
            if !isMotionReduced {
                LottieView(animationType: viewModel.isCorrect ? .correct : .incorrect)
            }

            VerticalTextAnimationView(viewModel:
                VerticalTextAnimationViewModel(
                    text: viewModel.priorAnswer,
                    isCorrect: viewModel.isCorrect,
                    completion: {
                        withAnimation {
                            viewModel.animationCompleted()
                        }
                    }
                )
            )
        }
    }
}
struct FloatingAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        FloatingAnimationView(viewModel: TrainingViewModel())
    }
}
