//
//  WebView.swift
//  FakeNFT
//
//  Created by Anastasia on 03.06.2025.
//

import SwiftUI

struct WebView: View {
    @State private var isLoading = true
    let url: URL?
    
    var body: some View {
        ZStack {
            WebViewRepresentable(isLoading: $isLoading, url: url)
            LoadingView()
                .opacity(isLoading ? 1 : 0)
        }
        .edgesIgnoringSafeArea(.all)
        .modifier(NavigationBarStyle(
            title: nil,
            backButtonHidden: false,
            filterButtonHidden: true,
            filterButtonTapHandler: { }
        ))
    }
}

#Preview {
    NavigationView {
        WebView(url: URL(string: "https://practicum.yandex.ru"))
    }
}
