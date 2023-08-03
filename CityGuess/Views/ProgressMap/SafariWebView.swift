//
//  SafariWebView.swift
//  CityGuess
//
//  Created by Tom Phillips on 7/21/23.
//

import SwiftUI
import SafariServices

struct SafariWebView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url )
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
    }
}
