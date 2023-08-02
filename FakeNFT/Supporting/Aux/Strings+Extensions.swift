//
//  Strings+Extensions.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 28.07.2023.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var encodeUrl: String {
        addingPercentEncoding(
            withAllowedCharacters: NSCharacterSet.urlQueryAllowed
        )!
    }
    
    var decodeUrl: String {
        removingPercentEncoding!
    }
}
