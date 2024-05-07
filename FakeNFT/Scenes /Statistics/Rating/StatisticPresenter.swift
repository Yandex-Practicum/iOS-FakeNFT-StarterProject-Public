//
//  StatisticPresenter.swift
//  FakeNFT
//
//  Created by Сергей on 23.04.2024.
//

import UIKit
import Alamofire

protocol StatisticPresenterProtocol: AnyObject {
   
    func viewDidLoad()
    var view: StatisticsViewControllerProtocol? { get set }
    var objects: [Person] { get set }
}

final class StatisticsPresenter: StatisticPresenterProtocol {
    let didChangeNotification = Notification.Name(rawValue: "StatisticServiceDidChange")
    private var imageListServiceObserver: NSObjectProtocol?
    var view: StatisticsViewControllerProtocol?
    var objects: [Person] = []
    
    
    func viewDidLoad() {
        observeAnimate()
    }
    
    func sortByName() {
        
    }
    
    func observeAnimate() {
        UIBlockingProgressHUD.show()
        imageListServiceObserver = NotificationCenter.default.addObserver(
            forName: didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self = self else { return }
                view?.updateCollectionViewAnimate()
            }
        StatisticService.shared.fetchNextPage()
    }
}


