//
//  LearnMoreView.swift
//  CityGuess
//
//  Created by Tom Phillips on 7/24/23.
//

import SwiftUI

struct LearnMoreView: View {
    let cityImage: CityImage
    @State private var cityScores = [CityScore]()

    var url: URL? {
        URL(string: cityImage.url)
    }

    var body: some View {
        VStack {
            Text(cityImage.title)
                .font(.largeTitle)
            AsyncImage(url: url) { phase in
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
            
            Text("Categores: \(cityScores.count)")
        }
        .task {
            do {
                cityScores = try await TeleportApiClient().fetchScores(for: TeleportCity(href: "https://api.teleport.org/api/urban_areas/slug:detroit/", name: "Detroit"))
            } catch {
                print(error)
            }
            
        
        }
        
    }
}

struct LearnMoreView_Previews: PreviewProvider {
    static var previews: some View {
        LearnMoreView(cityImage: CityImage(title: "Detroit", url: "https://d13k13wj6adfdf.cloudfront.net/urban_areas/detroit-e0a9dfeff2.jpg"))
    }
}
