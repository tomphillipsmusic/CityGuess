//
//  GameStartView.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/10/23.
//

import SwiftUI

struct GameStartView: View {
    @ObservedObject var vm: CityGuessViewModel
    var body: some View {
        Button("Start") {
            vm.startGame()
        }
        .disabled(vm.cityImages.isEmpty)
    }
}

struct GameStartView_Previews: PreviewProvider {
    static var previews: some View {
        GameStartView(vm: CityGuessViewModel(cityService: JsonCityService(), imageFetcher: RedditClient()))
    }
}
