//
//  ContentView.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/6/23.
//

import SwiftUI

struct TrainingView: View {
    @StateObject var vm = TrainingViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                
                if !vm.isPlaying {
                    TrainingStartView(vm: vm)
                } else if vm.isGameOver {
                    TrainingEndView(vm: vm)
                } else {
                    CityGuessView(vm: vm)
                }
            }
            .navigationTitle("Training")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            await vm.fetchCityImages()
        }
    }
}

struct TrainingView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingView()
    }
}
