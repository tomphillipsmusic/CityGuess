//
//  FloatingAnimationView.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/21/23.
//

import SwiftUI

struct FloatingAnimationView<ViewModel: CityGuessViewModel>: View {
    @ObservedObject var vm: ViewModel

    var body: some View {
        ZStack {
            LottieView(animationType: vm.isCorrect ? .correct : .incorrect)
            VerticalTextAnimationView(vm:
                VerticalTextAnimationViewModel(text: vm.priorAnswer, isCorrect: vm.isCorrect) {
                vm.animationCompleted()
            })
        }
    }
}
struct FloatingAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        FloatingAnimationView(vm: TrainingViewModel())
    }
}
