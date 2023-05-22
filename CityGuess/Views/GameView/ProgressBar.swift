//
//  ProgressBar.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/25/23.
//

import SwiftUI

struct ProgressBar: View {
    var progress: CGFloat
    let questions: [Question]

    var body: some View {
        GeometryReader { geo in

            HStack {
                ForEach(questions) { question in
                    Rectangle()
                        .foregroundColor(question.color)
                        .frame(maxWidth: geo.size.width / CGFloat(questions.count - 2))
                        .animation(.linear, value: progress)
                }
            }
            .cornerRadius(45.0)
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(progress: 20.0, questions: [
            Question(state: .correct, text: "answer"),
            Question(state: .incorrect, text: "asdf"),
            Question(state: .correct, text: "ansasdfasdfwer"),
            Question(state: .incorrect, text: "asdfasd"),
            Question(text: "asdfasdfasdfas")
        ])
    }
}
