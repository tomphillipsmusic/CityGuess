//
//  CityMapViewCoordinator.swift
//  CityGuess
//
//  Created by Tom Phillips on 6/13/23.
//

import MapKit
import WebKit

class CityMapViewCoordinator: NSObject, MKMapViewDelegate, WKUIDelegate {
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
            let learnMoreButton = LearnMoreButton(cityName: annotation.title)

            let stackView = UIStackView(arrangedSubviews: [calloutDetailLabel, learnMoreButton])
            stackView.axis = .vertical

            annotationView.detailCalloutAccessoryView = stackView
            
//            NSLayoutConstraint.activate([
//                calloutDetailLabel.topAnchor.constraint(equalTo: annotationView.topAnchor, constant: 8),
//                calloutDetailLabel.heightAnchor.constraint(equalToConstant: 10),
//                calloutDetailLabel.leadingAnchor.constraint(equalTo: annotationView.leadingAnchor, constant: 8),
//                calloutDetailLabel.trailingAnchor.constraint(equalTo: annotationView.trailingAnchor, constant: 8),
//                
//                learnMoreButton.topAnchor.constraint(equalTo: calloutDetailLabel.bottomAnchor, constant: 8),
//                learnMoreButton.heightAnchor.constraint(equalToConstant: 10),
//                learnMoreButton.leadingAnchor.constraint(equalTo: annotationView.leadingAnchor, constant: 8),
//                learnMoreButton.trailingAnchor.constraint(equalTo: annotationView.trailingAnchor, constant: 8)
//            ])
            
            return annotationView
    }

        return nil
    }
    
    @objc private func loadLearnMore() {
        if let cityName {
            mapViewController.selectedCityUrl = URL(string: "https://en.m.wikipedia.org/wiki/\(cityName)")
        }
//        webView = WKWebView()
//        webView.uiDelegate = self
//
//        learnMoreURL = URL(string: "https://www.google.com")
//        if let url = learnMoreURL {
//            let urlRequest = URLRequest(url: url)
//            webView.load(urlRequest)
//        }
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
