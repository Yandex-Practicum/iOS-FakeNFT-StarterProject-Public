//
//  WebsiteViewModelProtocol.swift
//  FakeNFT
//

import Foundation

protocol WebsiteViewModelProtocol {
    var websiteURLRequest: URLRequest { get }
    var progressValueObservable: Observable<Float> { get }
    var shouldHideProgress: Bool { get }
    func received(_ newProgressValue: Double)
}
