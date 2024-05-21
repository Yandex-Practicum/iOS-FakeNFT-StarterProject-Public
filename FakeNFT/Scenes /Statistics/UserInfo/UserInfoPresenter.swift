//
//  UserInfoViewPresenter.swift
//  FakeNFT
//
//  Created by Сергей on 26.04.2024.
//

import Foundation

protocol UserInfoPresenterProtocol {
    var object: Person? { get set }
}

final class UserInfoPresenter: UserInfoPresenterProtocol {

    var object: Person?
}
