//
//  ExploreCitiesView.swift
//  CityGuess
//
//  Created by Tom Phillips on 5/23/23.
//

import SwiftUI
import MapKit

struct ExploreCitiesView: View {
    @StateObject var viewModel = ExploreCitiesViewModel()
    @Binding var currentScreen: Router.Screen

    var body: some View {
        NavigationStack {
            CityMapView(cityCoordinates: viewModel.coordinates)
            .navigationTitle("Explore")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back \(viewModel.coordinates.count)") {
                        currentScreen = .menu
                    }
                }
            }
        }
    }
}

struct ExploreCitiesView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreCitiesView(currentScreen: .constant(.explore))
    }
}
