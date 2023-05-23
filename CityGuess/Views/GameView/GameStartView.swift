//
//  GameStartView.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/10/23.
//

import SwiftUI
import CachedAsyncImage

struct GameStartView<ViewModel: CityGuessViewModel>: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: viewModel.cityImages.randomElement()?.url ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: UIScreen.main.bounds.width)
                    .opacity(0.8)
            } placeholder: {
                Color.secondary
            }

            VStack {
                Text(viewModel.gameHeadline)
                    .font(.title)
                    .padding()

                Text(viewModel.gameDescription)
                    .font(.headline)

                HStack {
                    Text("Number of Cities:")

                    Picker("Number of Cities", selection: $viewModel.numberOfRounds) {
                        ForEach(viewModel.roundOptions, id: \.self) {
                            Text("\($0)")
                                .tag($0)
                        }
                        .onChange(of: viewModel.numberOfRounds) { newValue in
                            withAnimation(.easeInOut(duration: 0.5)) {
                                viewModel.questions = Array(repeating: Question(text: ""), count: newValue)
                            }
                        }
                    }
                }

                Button(viewModel.startGameButtonText) {
                    viewModel.startGame(with: viewModel.numberOfRounds)
                }
                .disabled(viewModel.cityImages.isEmpty)
                .padding()
            }
            .background(
                .background
                    .opacity(0.9)
            )
        }
    }
}

struct GameStartView_Previews: PreviewProvider {
    static var previews: some View {
        GameStartView(viewModel: TrainingViewModel())
    }
}
