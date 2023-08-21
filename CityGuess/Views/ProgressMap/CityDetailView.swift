//
//  LearnMoreView.swift
//  CityGuess
//
//  Created by Tom Phillips on 7/24/23.
//

import SwiftUI
import MapKit

struct CityDetailView: View {
    @StateObject var viewModel: CityDetailViewModel
    @StateObject var exploreCityViewModel: ProgressMapViewModel<TeleportCoordinatesService, TeleportApiClient>

    init(viewModel: CityDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _exploreCityViewModel = StateObject(wrappedValue: ProgressMapViewModel(
            city: viewModel.city,
            citiesClient: TeleportApiClient(),
            coordinatesService: TeleportCoordinatesService()
        ))
    }

    var body: some View {
        VStack {
            heading
            flippableCityImage
            learnMoreButton
            Divider()

            if viewModel.shouldDisplayCityStats {
                ScrollView {
                    CityScoresView(cityScores: viewModel.cityScores)
                }
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
                .padding()

            Text(viewModel.guessHistory.continent.rawValue)
                .font(.title2)
        }
    }

    var flippableCityImage: some View {
        GeometryReader { geo in
            FlippableContent {
                cityImage
            } back: {
                CityMapView(
                    cityCoordinates: exploreCityViewModel.coordinates,
                    guessHistory: [viewModel.cityName: viewModel.guessHistory],
                    selectedCityHistory: $exploreCityViewModel.selectedCity,
                    selectedContinent: .constant(nil)
                )
                .cornerRadius(20)
                .padding()
            }
            .frame(width: geo.size.width, height: geo.size.height)
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
        CityDetailView(viewModel: CityDetailViewModel(guessHistory: CityGuessHistory(
            name: "Detroit",
            continent: .northAmerica,
            urlString: "https://d13k13wj6adfdf.cloudfront.net/urban_areas/detroit-e0a9dfeff2.jpg")
        )
    )}
}
