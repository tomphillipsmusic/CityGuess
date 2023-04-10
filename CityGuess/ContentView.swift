//
//  ContentView.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/6/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = CityGuessViewModel(cityService: JsonCityService(), imageFetcher: RedditApiClient())
    
    var body: some View {
        NavigationStack {
            
            VStack {
                
                if !vm.isPlaying {
                    Button("Start") {
                        vm.isPlaying = true
                    }
                    .disabled(vm.cityImages.isEmpty)
                } else {
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

                        TextField("Guess", text: $vm.guess)
                        Button("Guess") {
                            vm.submit()
                        }
                    }
                }
            }
            .navigationTitle("City Guess")
        }
        .task {
            await vm.fetchCityImages()
            print(vm.cities.count)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
