//
//  String + Extension.swift
//  FakeNFT
//
//  Created by Денис Николаев on 16.07.2024.
//

import Foundation

extension String {

    var urlDecoder: String {
        return self.removingPercentEncoding!
    }

    var urlEncoder: String {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
}
