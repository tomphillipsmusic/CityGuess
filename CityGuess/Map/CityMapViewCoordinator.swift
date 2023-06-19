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
        if let annotation = annotation as? CityMapAnnotation {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "city-annotation")
            annotationView.image = UIImage(systemName: "building.2.fill")
            annotationView.backgroundColor = annotation.history.guessStatus == .right ? .green : annotation.history.guessStatus == .wrong ? .red : .gray
            annotationView.canShowCallout = true
            return annotationView
        }

        return nil
    }

}
