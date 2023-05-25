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
            Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.coordinates) { coordinate in
                MapAnnotation(coordinate: coordinate.clLocationCoordinate2D) {
                    Text(coordinate.name)
                }
            }
            .navigationTitle("Explore")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back \(viewModel.coordinates.count)") {
                        currentScreen = .menu
                    }
                }
            }
            .task {
                await viewModel.fetchCoordinates()
            }
        }
    }
}

struct ExploreCitiesView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreCitiesView(currentScreen: .constant(.explore))
    }
}
