//
//  Double+Formatting.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 04.08.2023.
//

import Foundation

extension Double {
    var nftCurrencyFormatted: String {
        let formatter = NumberFormatter.doubleFormatter
        let string = formatter.string(from: self as NSNumber)
        return string ?? ""
    }
}
