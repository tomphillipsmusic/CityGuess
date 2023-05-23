//
//  Router.swift
//  CityGuess
//
//  Created by Tom Phillips on 5/9/23.
//

import Foundation

class Router: ObservableObject {
    @Published var currentScreen: Screen = .menu

    enum Screen {
        case menu, training, challenge
    }
}
