//
//  MapView.swift
//  CityGuess
//
//  Created by Tom Phillips on 6/13/23.
//

import SwiftUI
import MapKit

struct CityMapView: UIViewRepresentable {
    @Binding var selectedCityHistory: CityGuessHistory?
    @Binding var selectedContinent: CGContinent?

    var locationManager = CLLocationManager()
    let annotations: [CityMapAnnotation]

    init(
        cityCoordinates: [CityCoordinate],
        guessHistory: [String: CityGuessHistory],
        selectedCityHistory: Binding<CityGuessHistory?>,
        selectedContinent: Binding<CGContinent?>
    ) {
        annotations = cityCoordinates.filter { guessHistory[$0.name] != nil }.compactMap {
            if guessHistory[$0.name] != nil {
                return CityMapAnnotation(cityCoordinate: $0, history: guessHistory[$0.name]!)
            }

            return nil
        }

        _selectedCityHistory = selectedCityHistory
        _selectedContinent = selectedContinent
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator

        if annotations.count == 1 {
            configureSingleCity(mapView)
        }

        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.addAnnotations(annotations)

        if let selectedContinent {
            resetCameraTo(selectedContinent, on: mapView)
        }

        if annotations.count == 1 {
            configureSingleCity(mapView)
        }
    }

    private func resetCameraTo(_ selectedContinent: CGContinent, on mapView: MKMapView) {
        let camera = MKMapCamera(
            lookingAtCenter: selectedContinent.geographicCenter,
            fromEyeCoordinate: selectedContinent.geographicCenter,
            eyeAltitude: 1_000_000_000
        )

        DispatchQueue.main.async {
            mapView.setCamera(camera, animated: true)
            self.selectedContinent = nil
        }
    }

    private func configureSingleCity(_ mapView: MKMapView) {
        if let firstAnnotation = annotations.first {
            let coordinateSpan = MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
            mapView.region = MKCoordinateRegion(center: firstAnnotation.coordinate, span: coordinateSpan)
            mapView.isScrollEnabled = false
            mapView.isZoomEnabled = false
        }
    }

    func makeCoordinator() -> CityMapViewCoordinator {
        CityMapViewCoordinator(cityMapView: self)
    }
}
