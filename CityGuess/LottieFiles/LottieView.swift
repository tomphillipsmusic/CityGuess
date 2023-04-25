//
//  LottieView.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/21/23.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {

    var animationType: AnimationType

    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: .zero)
        let animationView = LottieAnimationView()
        let animation = LottieAnimation.named(animationType.name)

        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed *= animationType.speedMultiplier
        
        animationView.play { _ in
            animationView.removeFromSuperview()
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
