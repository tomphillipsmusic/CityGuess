//
//  LearnMoreButton.swift
//  CityGuess
//
//  Created by Tom Phillips on 7/18/23.
//

import UIKit

class LearnMoreButton: UIButton {
    var cityName: String?
    var mapViewController: CityMapView!

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(cityName: String?) {
        self.cityName = cityName
        super.init(frame: .zero)
        configure()
    }

    private func configure() {
        titleLabel?.text = "Learn More"
        layer.cornerRadius = 10
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        //translatesAutoresizingMaskIntoConstraints = false
        addTarget(self, action: #selector(loadLearnMore), for: .touchUpInside)
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
}
