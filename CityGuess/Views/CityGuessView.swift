//
//  CityGuessView.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/10/23.
//

import SwiftUI

struct CityGuessView: View {
    @ObservedObject var vm: CityGuessViewModel
    @State private var guess = ""
    
    var body: some View {
        VStack {
            Text(vm.priorAnswer)
                .foregroundColor(vm.isCorrect ? .green : .red)
            Text("Score: \(vm.score)")
            AsyncImage(url: URL(string: vm.cityImages[vm.currentCityIndex].url)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            
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
}

struct CityGuessView_Previews: PreviewProvider {
    static var previews: some View {
        CityGuessView(vm: CityGuessViewModel())
    }
}
