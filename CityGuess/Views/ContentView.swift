//
//  ContentView.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/6/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm = CityGuessViewModel<TeleportApiClient.TeleportCity>(cityService: LocalCityService(), imageFetcher: TeleportApiClient())
    
    var body: some View {
        NavigationStack {
            VStack {
                
                if !vm.isPlaying {
                  GameStartView(vm: vm)
                } else {
                    CityGuessView(vm: vm)
                }
            }
            .navigationTitle("City Guess")
        }
        .task {
            await vm.fetchCityImages()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
