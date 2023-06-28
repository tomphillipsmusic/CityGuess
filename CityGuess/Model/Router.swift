//
//  Router.swift
//  CityGuess
//
//  Created by Tom Phillips on 5/9/23.
//

import SwiftUI

class Router: ObservableObject {
    @Published var path = NavigationPath()

    enum Screen {
        case training, challenge, explore
    }
}
