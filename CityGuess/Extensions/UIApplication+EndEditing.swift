//
//  UIApplication+EndEditing.swift
//  CityGuess
//
//  Created by Tom Phillips on 6/30/23.
//

import UIKit

// https://stackoverflow.com/questions/56491386/how-to-hide-keyboard-when-using-swiftui/57639614#57639614
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
