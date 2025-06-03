//
//  UserAvatar.swift
//  FakeNFT
//
//  Created by Anastasia on 03.06.2025.
//

import SwiftUI

struct UserAvatar: View {
    
    let url: String
    let size: CGFloat
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .frame(width: size, height: size)
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
            case .failure, .empty:
                Image("userpick")
                    .resizable()
                    .frame(width: size, height: size)
            default:
                EmptyView()
            }
        }
    }
}

#Preview {
    UserAvatar(url: "", size: 28.0)
}
