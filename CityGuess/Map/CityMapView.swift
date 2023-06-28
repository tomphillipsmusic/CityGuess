//
//  MapView.swift
//  CityGuess
//
//  Created by Tom Phillips on 6/13/23.
//

import SwiftUI
import MapKit

struct CityMapView: UIViewRepresentable {
    var locationManager = CLLocationManager()
    let annotations: [CityMapAnnotation]

    init(cityCoordinates: [CityCoordinate], guessHistory: [String: CityGuessHistory]) {
        annotations = cityCoordinates.filter { guessHistory[$0.name] != nil }.compactMap {
            if guessHistory[$0.name] != nil {
                return CityMapAnnotation(cityCoordinate: $0, history: guessHistory[$0.name]!)
            }

            return nil
        }
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.addAnnotations(annotations)
    }

    func makeCoordinator() -> CityMapViewCoordinator {
        CityMapViewCoordinator(cityMapView: self)
    }
}
