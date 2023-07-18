//
//  Webview.swift
//  CityGuess
//
//  Created by Tom Phillips on 7/7/23.
//

import SwiftUI
import WebKit

extension URL: Identifiable {
    public var id: String { self.absoluteString }
}

struct WebView : UIViewRepresentable {
    
    let request: URLRequest
    
    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
    
}

struct WebView_Previews : PreviewProvider {
    static var previews: some View {
        WebView(request: URLRequest(url: URL(string: "https://www.apple.com")!))
    }
}
