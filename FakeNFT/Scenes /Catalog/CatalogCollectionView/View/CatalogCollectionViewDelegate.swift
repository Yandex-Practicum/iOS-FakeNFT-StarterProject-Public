//
//  CatalogCollectionViewDelegate.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 23.11.2023.
//

import Foundation

protocol CatalogCollectionViewDelegate: AnyObject {
    func dismissView()
    func showErrorAlert()
    func showNftInteractionErrorAlert()
    func startAnimatingActivityIndicator()
    func stopAnimatingActivityIndicator()
    func presentAuthorPage(_ url: URL?)
}
