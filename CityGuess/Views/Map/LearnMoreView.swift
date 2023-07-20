//
//  LearnMoreView.swift
//  CityGuess
//
//  Created by Tom Phillips on 7/20/23.
//

import SwiftUI

struct LearnMoreView: View {
    @Environment(\.dismiss) var dismiss
    let request: URLRequest
    private let webView: WebView

    init(request: URLRequest) {
        self.request = request
        webView = WebView(request: request)
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    webView.goBack()
                } label: {
                    Image(systemName: "chevron.left")
                }
//                .disabled(!webView.canGoBack)
                .padding()
                
                Button {
                    webView.goForward()
                } label: {
                    Image(systemName: "chevron.right")
                }
//                .disabled(!webView.canGoForward)
                .padding()

                Spacer()
                Button("Close") {
                    dismiss()                }
                .padding()
            }

            webView
        }
    }
}

struct LearnMoreView_Previews: PreviewProvider {
    static var previews: some View {
        LearnMoreView(request: URLRequest(url: URL(string: "https://www.google.com")!))
    }
}
