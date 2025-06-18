//
//  DeleteConfirmationView.swift
//  FakeNFT
//
//  Created by Max on 13.06.2025.
//

import SwiftUI

struct DeleteConfirmationView: View {
    let nft: Nft
    let onDelete: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        
        VStack(spacing: 24) {
            AsyncImage(url: URL(string: nft.images.first ?? "")) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.1))
                        ProgressView()
                    }
                    .frame(width: 108, height: 108)
                    
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 108, height: 108)
                        .clipped()
                        .cornerRadius(12)
                    
                case .failure:
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.1))
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.gray)
                    }
                    .frame(width: 108, height: 108)
                    
                @unknown default:
                    EmptyView()
                }
            }
            
            
            Text("Вы уверены, что хотите\nудалить объект из корзины?")
                .font(.regular13)
                .multilineTextAlignment(.center)
                .foregroundStyle(.primary)
            
            HStack(spacing: 8) {
                ButtonView(action: onDelete, textColor: .yaRedUniversal, buttonColor: .blackDay, text: "Удалить", font: .regular17, cornerRadius: 12, buttonHieght: 44)
                
                
                ButtonView(action: onCancel, textColor: .whiteDay, buttonColor: .blackDay, text: "Вернуться", font: .regular17, cornerRadius: 12, buttonHieght: 44)
            }
        }
        .padding(24)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
    }
}

#Preview {
    DeleteConfirmationView(nft: Nft.mock, onDelete: {}, onCancel: {})
}
