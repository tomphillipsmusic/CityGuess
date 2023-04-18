//
//  CityGuessView.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/10/23.
//

import SwiftUI
import CachedAsyncImage

struct CityGuessView<ViewModel: CityGuessViewModel>: View {
    @ObservedObject var vm: ViewModel
    @State private var guess = ""
    @State var lastScaleValue: CGFloat = 1.0
    @State private var autofillSuggestions = [ViewModel.CityModel]()
    @State private var zoomableScrollView = ZoomableScrollView() {}
        
    var body: some View {
        
        VStack {
            
            if vm.cityImages.isEmpty {
                ProgressView()
            } else {
                Text(vm.priorAnswer)
                    .foregroundColor(vm.isCorrect ? .green : .red)
                
                ZoomableImage(url: URL(string: vm.cityImages[vm.currentCityIndex].url))
                
                CityGuessTextField(text: $guess)
                
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
            }
        }
        
    }
}

struct CityGuessView_Previews: PreviewProvider {
    static var previews: some View {
        CityGuessView(vm: TrainingViewModel())
    }
}
