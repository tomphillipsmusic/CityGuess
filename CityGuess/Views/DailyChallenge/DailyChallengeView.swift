//
//  DailyChallengeView.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/14/23.
//

import SwiftUI

struct DailyChallengeView: View {
    @StateObject var vm = DailyChallengeViewModel()
    var body: some View {
        List {
            ForEach(vm.cityImages, id: \.url) { Text($0.title) }
        }
    }
}

struct DailyChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        DailyChallengeView()
    }
}
