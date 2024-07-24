//
//  StatisticsPresenter.swift
//  FakeNFT
//
//  Created by Vladimir Vinakheras on 12.07.2024.
//

import Foundation
import UIKit

protocol StatisticsPresenterProtocol: AnyObject {

}

final class StatisticsPresenter {

    weak var view: StatisticsViewProtocol?

    init(view: StatisticsViewProtocol?) {
        self.view = view
    }
}

// MARK: StatisticsPresenterProtocol

extension StatisticsPresenter: StatisticsPresenterProtocol {

}
