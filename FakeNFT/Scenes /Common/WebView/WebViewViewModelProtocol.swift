//
//  AuthorWebViewViewModelProtocol.swift
//  FakeNFT
//
//  Created by Eugene Kolesnikov on 22.11.2023.
//

import Foundation

protocol WebViewViewModelProtocol {
    var progressValue: Float { get set }
    var progressPublisher: Published<Float>.Publisher { get }
    var shouldHideProgress: Bool { get set }
    var progressStatePublisher: Published<Bool>.Publisher { get }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
}
