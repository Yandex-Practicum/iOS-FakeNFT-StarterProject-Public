//
//  CatalogViewDelegate.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 23.11.2023.
//

import Foundation

protocol CatalogViewDelegate: AnyObject {
    func selectedCategory(_ model: Catalog)
    func showErrorAlert()
    func startAnimatingActivityIndicator()
    func stopAnimatingActivityIndicator()
}
