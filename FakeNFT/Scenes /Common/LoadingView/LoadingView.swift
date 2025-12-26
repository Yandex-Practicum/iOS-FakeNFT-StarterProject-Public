//
//  LoadingView.swift
//  FakeNFT
//
//  Created by Anastasia on 25.05.2025.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.lightGrayDay)
            .frame(width: 82, height: 82)
            .overlay {
                ProgressView()
                    .tint(.blackDay)
                    .scaleEffect(1.5)
            }
    }
}

#Preview {
    LoadingView()
}
