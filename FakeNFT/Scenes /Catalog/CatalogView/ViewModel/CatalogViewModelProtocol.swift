//
//  CatalogViewModelProtocol.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 22.11.2023.
//

import Foundation

protocol CatalogViewModelProtocol: AnyObject {
    var catalog: [Catalog] { get set }
    var catalogPublisher: Published<Array<Catalog>>.Publisher { get }
    var isLoadingData: Bool { get }
    var loadingDataPublisher: Published<Bool>.Publisher { get }
    var networkError: Error? { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    func sortCatalogByName()
    func sortCatalogByQuantity()
    func sortCatalog()
    func fetchCatalog()
}
