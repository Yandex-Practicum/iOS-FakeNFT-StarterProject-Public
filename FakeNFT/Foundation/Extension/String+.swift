//
//  String+.swift
//  FakeNFT
//
//  Created by Kirill on 06.07.2023.
//

import Foundation

extension String {
    var encodeUrl: String {
        addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    var decodeUrl: String {
        removingPercentEncoding!
    }
}
