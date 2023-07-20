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

struct WebView: UIViewRepresentable {
    @State private var previousUrl: URL?
    
    let request: URLRequest
    @State private var webView: WKWebView?

    init(request: URLRequest) {
        _webView = State(initialValue: WKWebView()
        )
        self.request = request
    }

    func makeUIView(context: Context) -> WKWebView {
        return webView ?? WKWebView()
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        if request.url != previousUrl {
            webView.load(request)
            DispatchQueue.main.async { previousUrl = request.url
            }
        }
    }

    func goBack() {
        if let webView {
            webView.goBack()
        }
       // webView?.goBack()
    }

    func goForward() {
        webView?.goForward()
    }
    
    var canGoBack: Bool {
        webView?.canGoBack ?? false
    }
    
    var canGoForward: Bool {
        webView?.canGoForward ?? false
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        WebView(request: URLRequest(url: URL(string: "https://www.apple.com")!))
    }
}
