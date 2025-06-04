//
//  ShowWebViewButton.swift
//  FakeNFT
//
//  Created by Anastasia on 04.06.2025.
//

import SwiftUI

struct ShowWebViewButton: View {
    
    let url: String
    
    var body: some View {
        NavigationLink(
            destination: WebView(url: URL(string: url))
                .toolbar(.hidden, for: .tabBar)
        ) {
            Text("Перейти на сайт пользователя")
                .font(.regular15)
                .foregroundStyle(Color.blackDay)
                .frame(
                    maxWidth: .infinity,
                    maxHeight: StatisticsConstants.buttonHeightMedium
                )
                .background(
                    RoundedRectangle(cornerRadius: StatisticsConstants.cornerRadiusMedium)
                        .stroke(
                            Color.blackDay,
                            lineWidth: StatisticsConstants.borderLineWidth
                        )
                )
        }
    }
}

#Preview {
    NavigationStack {
        ShowWebViewButton(url: "")
    }
}
