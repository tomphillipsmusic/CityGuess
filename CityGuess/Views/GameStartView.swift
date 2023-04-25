//
//  GameStartView.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/10/23.
//

import SwiftUI
import CachedAsyncImage

struct GameStartView<ViewModel: CityGuessViewModel>: View {
    @ObservedObject var vm: ViewModel

    var body: some View {
        ZStack {
            CachedAsyncImage(url: URL(string: vm.cityImages.randomElement()?.url ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: UIScreen.main.bounds.width)
                    .opacity(0.8)
            } placeholder: {
                Color.secondary
            }

            VStack {
                Text(vm.gameHeadline)
                    .font(.title)
                    .padding()

                Text(vm.gameDescription)
                    .font(.headline)

                HStack {
                    Text("Number of Cities:")

                    Picker("Number of Cities", selection: $vm.numberOfRounds) {
                        ForEach(vm.roundOptions, id: \.self) {
                            Text("\($0)")
                                .tag($0)
                        }
                        .onChange(of: vm.numberOfRounds) { newValue in
                            withAnimation(.easeInOut(duration: 0.5)) {
                                vm.questions = Array(repeating: Question(text: ""), count: newValue)
                            }
                        }
                    }
                }

                Button(vm.startGameButtonText) {
                    vm.startGame(with: vm.numberOfRounds)
                }
                .disabled(vm.cityImages.isEmpty)
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
        GameStartView(vm: TrainingViewModel())
    }
}
