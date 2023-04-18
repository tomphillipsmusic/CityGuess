//
//  CityGuessView.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/10/23.
//

import SwiftUI
import CachedAsyncImage

struct CityGuessView<ViewModel: CityGuessViewModel>: View {
    enum Field {
        case guess
    }
    @ObservedObject var vm: ViewModel
    @State private var guess = ""
    @FocusState private var textFieldFocused: Bool
    @State private var opacity = 1.0
    @State private var autofillSuggestions = [ViewModel.CityModel]()
    
    var body: some View {
        
        VStack {
            
            if vm.cityImages.isEmpty {
                ProgressView()
            } else {
                Text(vm.priorAnswer)
                    .foregroundColor(vm.isCorrect ? .green : .red)
                        
                CachedAsyncImage(url: URL(string: vm.cityImages[vm.currentCityIndex].url)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                    
                } placeholder: {
                    ProgressView()
                }
                
                
                TextField("Guess", text: $guess)
                    .padding()
                    .disableAutocorrection(true)
                    .keyboardType(.alphabet)
                    .focused($textFieldFocused)
                    .onAppear {
                        textFieldFocused = true
                    }
                
                if !autofillSuggestions.isEmpty {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(autofillSuggestions, id: \.name) { autofill in
                                let cityName = autofill.name
                                
                                Button(cityName) {
                                    vm.submit(guess: cityName)
                                    self.guess = ""
                                }
                                .padding()
                                .buttonStyle(.bordered)
                                
                            }
                        }
                    }
                }
                
            }
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Text("\(vm.currentRound) / \(vm.numberOfRounds)")
                    .font(.title2)
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Text("Score: \(vm.score)")
                    .font(.title3)
       
            }
        }
        .onChange(of: guess) { guess in
            withAnimation {
                autofillSuggestions = vm.autofillSuggestions(for: guess)
                opacity = autofillSuggestions.isEmpty ? 1.0 : 0.2
            }
        }
        
    }
}
#warning("Check out Zoe's example of adding autofill for the keyboard. Figure out some kind of animation for showing right or wrong answers")

struct CityGuessView_Previews: PreviewProvider {
    static var previews: some View {
        CityGuessView(vm: TrainingViewModel())
    }
}
