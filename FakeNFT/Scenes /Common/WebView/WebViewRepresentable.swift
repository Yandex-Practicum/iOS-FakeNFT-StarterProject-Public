//
//  WebViewRepresentable.swift
//  FakeNFT
//
//  Created by Anastasia on 03.06.2025.
//

import SwiftUI
import WebKit

struct WebViewRepresentable: UIViewRepresentable {
    @Binding var isLoading: Bool
    let url: URL?
    
    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.navigationDelegate = context.coordinator
        webView.isOpaque = false
        webView.backgroundColor = .white
        
        if let url = url {
            webView.load(URLRequest(url: url))
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    final class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebViewRepresentable
        
        init(parent: WebViewRepresentable) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
        }
    }
}
