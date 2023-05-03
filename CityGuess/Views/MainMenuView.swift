//
//  MainMenuView.swift
//  CityGuess
//
//  Created by Tom Phillips on 5/3/23.
//

import SwiftUI

struct MainMenuView: View {
    @State private var isCompleted = true

    var body: some View {
        NavigationStack {
            ZStack {
                Image("city-skyline-background")
                    .resizable()
                    .scaledToFill()

                VStack {
                    Button("Training") {

                    }
                    .buttonStyle(.bordered)
                    .padding()

                    
                    ZStack {
                        if isCompleted {
                            Image("lock")
                                .resizable()
                                //.opacity(0.1)
                                .frame(width: 50, height: 50)
                        }
                      
                        Button("Daily Challenge") {

                        }
                        .disabled(isCompleted)
                        .buttonStyle(.bordered)
                        .padding()
                    }

                    Button("Unlock") {
                        withAnimation {
                            isCompleted.toggle()
                        }
                    }
                    
                    Spacer().frame(height: UIScreen.main.bounds.height * 0.4)
                }
            }
            .navigationTitle("City Guess")
        }
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}
