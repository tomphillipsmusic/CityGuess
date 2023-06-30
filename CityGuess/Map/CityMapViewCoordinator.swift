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
            annotationView.backgroundColor = backgroundColor(for: annotation.history.guessStatus)
            annotationView.canShowCallout = true

            var calloutDetailLabel = UILabel()
            calloutDetailLabel.text = annotation.subtitle
            calloutDetailLabel.adjustsFontForContentSizeCategory = false
            annotationView.detailCalloutAccessoryView = calloutDetailLabel
            return annotationView
    }

        return nil
    }

    private func backgroundColor(for guessStatus: CityGuessStatus) -> UIColor {
        switch guessStatus {
        case .wrong:
            return .red
        case .right:
            return .green
        case .notSeen:
            return .gray
        }
    }
}
