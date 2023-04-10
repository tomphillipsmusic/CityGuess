//
//  CityGuessView.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/10/23.
//

import SwiftUI

struct CityGuessView: View {
    @ObservedObject var vm: CityGuessViewModel
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
                    ForEach(vm.autofillSuggestions) { autofill in
                        let cityName = autofill.name
                        Button(autofill.name) {
                            vm.submit(guess: cityName)
                        }
                        .padding()
                        
                    }
                }
            }
            
            TextField("Guess", text: $vm.guess)
                .padding()

        }
        
    }
}

struct CityGuessView_Previews: PreviewProvider {
    static var previews: some View {
        CityGuessView(vm: CityGuessViewModel())
    }
}
