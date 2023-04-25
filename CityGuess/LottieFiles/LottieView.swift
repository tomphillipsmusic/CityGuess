//
//  LottieView.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/21/23.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {

    var animationName: String

    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: .zero)

        let animationView = LottieAnimationView()
        let animation = LottieAnimation.named(animationName)

        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        
        if animationName == "correct" {
            animationView.animationSpeed *= 1.45
        }
        animationView.play { _ in
            animationView.removeFromSuperview()
            print(animationName + " \(animation?.duration)" )
        }

        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {

    }
}
