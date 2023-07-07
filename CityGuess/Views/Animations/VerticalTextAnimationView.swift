//
//  VerticalTextAnimationView.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/21/23.
//

import SwiftUI

struct VerticalTextAnimationView: View {
    @StateObject var viewModel: VerticalTextAnimationViewModel
    @Environment(\.accessibilityReduceMotion) var isMotionReduced

    var body: some View {
        Text(viewModel.text)
            .padding()
            .background(RoundedRectangle(cornerRadius: 10.0).foregroundColor(Color("Background")))
            .font(.largeTitle)
            .opacity(viewModel.opacity)
            .onAppear {
                print(viewModel.text.count)
                viewModel.beginAnimation()
            }
            .if(!isMotionReduced) { view in
                view
                    .if(viewModel.canOffset) { view in
                        view.offset(y: viewModel.offset)
                    }
                    .animation(.easeInOut(duration: 1.5), value: viewModel.offset)
                    .animation(.easeInOut(duration: 1.5), value: viewModel.isAnimating)
            }
    }
}

struct VerticalTextAnimationView_Previews: PreviewProvider {

    static var previews: some View {
        VerticalTextAnimationView(viewModel: VerticalTextAnimationViewModel(text: "Hello", isCorrect: false) {
        })
    }
}
