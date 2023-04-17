//
//  CityGuessView.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/10/23.
//

import SwiftUI
import CachedAsyncImage

struct CityGuessView: View {
    @ObservedObject var vm: TrainingViewModel
    @State private var guess = ""

    var body: some View {
        VStack {
            if vm.cityImages.isEmpty {
                ProgressView()
            } else {
                Text(vm.priorAnswer)
                    .foregroundColor(vm.isCorrect ? .green : .red)
                Text("Score: \(vm.score)")
                    .padding()
                
                CachedAsyncImage(url: URL(string: vm.cityImages[vm.currentCityIndex].url)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                
                Spacer()
                ScrollView(.horizontal){
                    VStack(alignment: .center) {
                        ForEach(vm.autofillSuggestions(for: guess)) { autofill in
                            let cityName = autofill.name
                            Button(autofill.name) {
                                vm.submit(guess: cityName)
                                self.guess = ""
                            }
                            .padding()
                            
                        }
                    }
                }
                
                TextField("Guess", text: $guess)
                    .padding()
            }
                
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Text("\(vm.currentRound) / \(vm.numberOfRounds)")
                    .font(.title2)
            }
        }
    }
}

struct CityGuessView_Previews: PreviewProvider {
    static var previews: some View {
        CityGuessView(vm: TrainingViewModel())
    }
}
