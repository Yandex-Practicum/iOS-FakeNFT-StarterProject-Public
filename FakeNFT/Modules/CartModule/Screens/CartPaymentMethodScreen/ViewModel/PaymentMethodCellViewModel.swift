//
//  PaymentMethodCellViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 23.06.2023.
//

import Foundation
import Combine

final class PaymentMethodCellViewModel {
    
    @Published private (set) var paymentMethodRow: PaymentMethodRow
    
    init(paymentMethodRow: PaymentMethodRow) {
        self.paymentMethodRow = paymentMethodRow
    }
    
    func createUrl(from stringUrl: String?) -> URL? {
        guard let stringUrl,
              let encodedStringUrl = stringUrl.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed)
        else { return nil }
        
        return URL(string: encodedStringUrl)
    }
}
