//
//  CityMapViewCoordinator.swift
//  CityGuess
//
//  Created by Tom Phillips on 6/13/23.
//

import MapKit

class CityMapViewCoordinator: NSObject, MKMapViewDelegate {
    var mapViewController: CityMapView
    var cityName: String?

    init(cityMapView: CityMapView) {
        self.mapViewController = cityMapView
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? CityMapAnnotation {
            cityName = annotation.title

            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "city-annotation")
            annotationView.image = UIImage(systemName: "building.2.fill")
            annotationView.backgroundColor = backgroundColor(for: annotation.history.guessStatus)
            annotationView.canShowCallout = true

            let calloutDetailLabel = UILabel()
            calloutDetailLabel.text = annotation.subtitle
            calloutDetailLabel.adjustsFontForContentSizeCategory = false
            calloutDetailLabel.translatesAutoresizingMaskIntoConstraints = false

            annotationView.detailCalloutAccessoryView = calloutDetailLabel

            let learnMoreButton = UIButton(type: .detailDisclosure)
            learnMoreButton.titleLabel?.text = "Learn More"
            annotationView.rightCalloutAccessoryView = learnMoreButton

            return annotationView
    }

        return nil
    }

    func mapView(
        _ mapView: MKMapView,
        annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl
    ) {
        guard let cityAnnotation = view.annotation as? CityMapAnnotation else { return
        }

        mapViewController.selectedCityUrl = cityAnnotation.url
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
