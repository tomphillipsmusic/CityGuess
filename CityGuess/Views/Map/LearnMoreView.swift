//
//  LearnMoreView.swift
//  CityGuess
//
//  Created by Tom Phillips on 7/24/23.
//

import SwiftUI

struct LearnMoreView: View {
    @StateObject var viewModel: LearnMoreViewModel

    var body: some View {
        ScrollView {
            heading
            cityImage
            learnMoreButton
            Divider()
            CityScoresView(cityScores: viewModel.cityScores)
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
