//
//  LearnMoreView.swift
//  CityGuess
//
//  Created by Tom Phillips on 7/24/23.
//

import SwiftUI
import MapKit

struct LearnMoreView: View {
    @StateObject var viewModel: LearnMoreViewModel
    @StateObject var exploreCityViewModel: ExploreCitiesViewModel<TeleportCoordinatesService, TeleportApiClient>
    @State private var degrees: Double = 0
    @State private var coordinateRegion = MKCoordinateRegion()
    
    init(viewModel: LearnMoreViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _exploreCityViewModel = StateObject(wrappedValue: ExploreCitiesViewModel(city: viewModel.city, citiesClient: TeleportApiClient(), coordinatesService: TeleportCoordinatesService()))
    }

    var body: some View {
        VStack {
            heading
        
            Group {
                if degrees == 0 {
                    cityImage
                } else {
                    CityMapView(
                        cityCoordinates: exploreCityViewModel.coordinates,
                        guessHistory: [viewModel.cityName: viewModel.guessHistory],
                        selectedCityHistory: $exploreCityViewModel.selectedCity
                    )
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                    .cornerRadius(20)
                    .padding()
                }
                
            }
            .rotation3DEffect(.degrees(degrees), axis: (x: 0, y: 1, z: 0))
            .onTapGesture {
                withAnimation {
                    degrees = degrees == 0 ? 180 : 0
                }
            }
            
            learnMoreButton
            Divider()
            
            ScrollView {
                CityScoresView(cityScores: viewModel.cityScores)
            }
        }
        .task {
            await viewModel.fetchScores()
        }
    }

    var heading: some View {
        Group {
            Text(viewModel.cityName)
                .font(.largeTitle)
                .foregroundColor(viewModel.guessHistoryLabelColor)
        }
    }

    var cityImage: some View {
        AsyncImage(url: viewModel.imageUrl) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(20)
                    .padding()
            case .empty:
                ProgressView()
            case .failure:
                Image(systemName: "building.2")
                    .foregroundColor(viewModel.guessHistoryLabelColor)
            @unknown default:
                Text("Unknown error has occured")
            }
        }
    }

    var learnMoreButton: some View {
        Link(destination: viewModel.learnMoreUrl!) {
            Text("Learn More")
                .font(.title)
                .disabled(viewModel.learnMoreUrl == nil)
                .padding()
        }
    }
}

struct LearnMoreView_Previews: PreviewProvider {
    static var previews: some View {
        LearnMoreView(viewModel: LearnMoreViewModel( guessHistory: CityGuessHistory(
                    name: "Detroit",
                    urlString: "https://d13k13wj6adfdf.cloudfront.net/urban_areas/detroit-e0a9dfeff2.jpg")
                )
        )
    }
}
