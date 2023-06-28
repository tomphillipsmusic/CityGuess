//
//  ContentView.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/6/23.
//

import SwiftUI

struct GameView<ViewModel: CityGuessViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            ProgressBar(progress: viewModel.gameProgress, questions: viewModel.questions)
                .frame(height: 20)
                .padding()
            
            if !viewModel.isPlaying {
                GameStartView(viewModel: viewModel)
            } else if viewModel.isGameOver {
                GameEndView(viewModel: viewModel)
            } else {
                CityGuessView(viewModel: viewModel)
            }
        }
        .navigationTitle(viewModel.modeTitle)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchCityImages()
        }
    }
}

struct TrainingView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(viewModel: TrainingViewModel())
    }
}
