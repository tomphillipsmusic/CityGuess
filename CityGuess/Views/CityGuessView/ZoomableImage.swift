//
//  CityGuessImage.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/18/23.
//

import SwiftUI
import CachedAsyncImage

struct ZoomableImage: View {
    let url: URL?

    var body: some View {
        AsyncImage(url: url) { image in
            ZoomableScrollView {
                image
                    .resizable()
                    .scaledToFit()
            }

        } placeholder: {
            VStack {
                Spacer()
                ProgressView()
                Spacer()
            }
        }
    }
}

struct CityGuessImage_Previews: PreviewProvider {
    static var previews: some View {
        ZoomableImage(url: URL(string: "https://i.redd.it/6gjh8em31bsa1.jpg"))
    }
}
