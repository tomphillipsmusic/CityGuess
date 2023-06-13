//
//  CityMapViewCoordinator.swift
//  CityGuess
//
//  Created by Tom Phillips on 6/13/23.
//

import MapKit

class CityMapViewCoordinator: NSObject, MKMapViewDelegate {
    var mapViewController: CityMapView

    init(cityMapView: CityMapView) {
        self.mapViewController = cityMapView
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "city-annotation")
        annotationView.image = UIImage(systemName: "building.2.fill")
        annotationView.backgroundColor = .green
        annotationView.canShowCallout = true
        return annotationView
    }

}
