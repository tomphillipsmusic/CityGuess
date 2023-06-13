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

    init(cityCoordinates: [CityCoordinate]) {
        annotations = cityCoordinates.map { CityMapAnnotation(cityCoordinate: $0) }
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
