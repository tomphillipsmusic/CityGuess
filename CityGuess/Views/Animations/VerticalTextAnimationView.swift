//
//  VerticalTextAnimationView.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/21/23.
//

import SwiftUI

struct VerticalTextAnimationView: View {
    @StateObject var vm: VerticalTextAnimationViewModel

    var body: some View {
        Text(vm.text)
            .padding()
            .background(RoundedRectangle(cornerRadius: 10.0).foregroundColor(Color("Background")))
            .font(.largeTitle)
            .opacity(vm.opacity)
            .offset(y: vm.offset)
            .animation(.easeInOut(duration: 1.5), value: vm.offset)
            .animation(.easeInOut(duration: 1.5), value: vm.isAnimating)

            .onAppear {
                vm.beginAnimation()
            }
    }
}

struct VerticalTextAnimationView_Previews: PreviewProvider {

    static var previews: some View {
        VerticalTextAnimationView(vm: VerticalTextAnimationViewModel(text: "Hello", isCorrect: false) {
        })
    }
}
