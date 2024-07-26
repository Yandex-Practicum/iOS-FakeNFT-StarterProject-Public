//
//  UserCardPresenter.swift
//  FakeNFT
//
//  Created by Vladimir Vinakheras on 12.07.2024.
//

import Foundation
import UIKit

protocol UserCardPresenterProtocol: AnyObject {

}

final class UserCardPresenter {

    weak var view: UserCardViewProtocol?

    init(view: UserCardViewProtocol?) {
        self.view = view
    }
}

// MARK: UserCardPresenterProtocol

extension UserCardPresenter: UserCardPresenterProtocol {

}
