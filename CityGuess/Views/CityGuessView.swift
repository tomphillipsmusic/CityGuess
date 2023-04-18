//
//  CityGuessView.swift
//  CityGuess
//
//  Created by Tom Phillips on 4/10/23.
//

import SwiftUI
import CachedAsyncImage

struct CityGuessView<ViewModel: CityGuessViewModel>: View {
    @ObservedObject var vm: ViewModel
    @State private var guess = ""
    @State var lastScaleValue: CGFloat = 1.0
    @FocusState private var textFieldFocused: Bool
    @State private var autofillSuggestions = [ViewModel.CityModel]()
    @State private var zoomableScrollView = ZoomableScrollView() {}
        
    var body: some View {
        
        VStack {
            
            if vm.cityImages.isEmpty {
                ProgressView()
            } else {
                Text(vm.priorAnswer)
                    .foregroundColor(vm.isCorrect ? .green : .red)
                        
                CachedAsyncImage(url: URL(string: vm.cityImages[vm.currentCityIndex].url)) { image in
                    ZoomableScrollView {
                        image
                            .resizable()
                            .scaledToFit()
                    }
                    
                } placeholder: {
                    ProgressView()
                }
                
                TextField("Guess", text: $guess)
                    .padding()
                    .disableAutocorrection(true)
                    .keyboardType(.alphabet)
                    .focused($textFieldFocused)
                    .onAppear {
                        textFieldFocused = true
                    }
                
                if !autofillSuggestions.isEmpty {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(autofillSuggestions, id: \.name) { autofill in
                                let cityName = autofill.name
                                
                                Button(cityName) {
                                    vm.submit(guess: cityName)
                                    self.guess = ""
                                }
                                .padding()
                                .buttonStyle(.bordered)
                                
                            }
                        }
                    }
                }
                
            }
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Text("\(vm.currentRound) / \(vm.numberOfRounds)")
                    .font(.title2)
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Text("Score: \(vm.score)")
                    .font(.title3)
       
            }
        }
        .onChange(of: guess) { guess in
            withAnimation {
                autofillSuggestions = vm.autofillSuggestions(for: guess)
            }
        }
        
    }
}

struct CityGuessView_Previews: PreviewProvider {
    static var previews: some View {
        CityGuessView(vm: TrainingViewModel())
    }
}

// https://stackoverflow.com/questions/58341820/isnt-there-an-easy-way-to-pinch-to-zoom-in-an-image-in-swiftui
struct ZoomableScrollView<Content: View>: UIViewRepresentable {
  private var content: Content

  init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }

  func makeUIView(context: Context) -> UIScrollView {
    // set up the UIScrollView
    let scrollView = UIScrollView()
    scrollView.delegate = context.coordinator  // for viewForZooming(in:)
    scrollView.maximumZoomScale = 20
    scrollView.minimumZoomScale = 1
    scrollView.bouncesZoom = true

    // create a UIHostingController to hold our SwiftUI content
    let hostedView = context.coordinator.hostingController.view!
    hostedView.translatesAutoresizingMaskIntoConstraints = true
    hostedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    hostedView.frame = scrollView.bounds
    scrollView.addSubview(hostedView)

    return scrollView
  }

  func makeCoordinator() -> Coordinator {
    return Coordinator(hostingController: UIHostingController(rootView: self.content))
  }

  func updateUIView(_ uiView: UIScrollView, context: Context) {
    // update the hosting controller's SwiftUI content
    context.coordinator.hostingController.rootView = self.content
    assert(context.coordinator.hostingController.view.superview == uiView)
  }

  // MARK: - Coordinator

  class Coordinator: NSObject, UIScrollViewDelegate {
    var hostingController: UIHostingController<Content>

    init(hostingController: UIHostingController<Content>) {
      self.hostingController = hostingController
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
      return hostingController.view
    }
  }
}
