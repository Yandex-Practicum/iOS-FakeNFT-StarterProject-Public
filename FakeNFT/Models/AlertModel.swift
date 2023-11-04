//
//  AlertModel.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 04.11.2023.
//

import Foundation

struct AlertModel {
    let message: String
    let nameSortText: String
    let quantitySortText: String
    let cancelButtonText: String
    let sortNameCompletion: () -> ()
    let sortQuantityCompletion: () -> ()
}


