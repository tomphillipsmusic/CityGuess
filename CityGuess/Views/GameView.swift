//
//  ContentView.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/6/23.
//

import SwiftUI

struct GameView<ViewModel: CityGuessViewModel>: View {
    @StateObject var vm: ViewModel

    var body: some View {
        NavigationStack {
            VStack {
                ProgressBar(progress: CGFloat(vm.currentCityIndex) / CGFloat(vm.roundLength), questions: vm.questions)
                        .frame(height: 20)
                        .padding()
                
                if !vm.isPlaying {
                    GameStartView(vm: vm)
                } else if vm.isGameOver {
                    GameEndView(vm: vm)
                } else {
                    CityGuessView(vm: vm)
                }
            }
            .navigationTitle(vm.modeTitle)
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            await vm.fetchCityImages()
        }
    }
}

struct TrainingView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(vm: TrainingViewModel())
    }
}
