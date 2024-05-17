//
//  StatisticPresenter.swift
//  FakeNFT
//
//  Created by Сергей on 23.04.2024.
//

import UIKit
import Alamofire

protocol StatisticPresenterProtocol: AnyObject {
    
    var view: StatisticsViewControllerProtocol? { get set }
    var objects: [Person] { get set }
    func viewDidLoad()
    func createSortAlert(view: UIViewController, collection: UICollectionView)
    func createErrorAlert(view: UIViewController)
    func sortUsers()
}

final class StatisticsPresenter: StatisticPresenterProtocol {
    
    private let statisticService = StatisticService.shared
    let didChangeNotification = Notification.Name(rawValue: "StatisticServiceDidChange")
    private var imageListServiceObserver: NSObjectProtocol?
    weak var view: StatisticsViewControllerProtocol?
    var objects: [Person] = []
    
    func viewDidLoad() {
        observeAnimate()
    }
    
    func sortRating(sort value: String) {
        
        switch value {
        case "Name":
            let sortedObjects = objects.sorted { $0.name < $1.name }
            objects = sortedObjects
        case "Rating":
            let sortedObjects = objects.sorted { $0.nfts.count > $1.nfts.count }
            objects = sortedObjects
        default:
            break
        }
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
    
    func createSortAlert(view: UIViewController, collection: UICollectionView) {
        let alertController =  UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        let nameAction = UIAlertAction(title: "По имени", style: .default) { action in
            UserDefaults.standard.set("Name", forKey: "sortBy")
            self.sortRating(sort: "Name")
            collection.reloadData()
        }
        let ratingAction = UIAlertAction(title: "По рейтингу", style: .default) { action in
            UserDefaults.standard.set("Rating", forKey: "sortBy")
            self.sortRating(sort: "Rating")
            collection.reloadData()
            
        }
        
        let closeAction = UIAlertAction(title: "Закрыть", style: .cancel) { action in
            view.dismiss(animated: true)
        }
        
        [nameAction, ratingAction, closeAction].forEach {
            alertController.addAction($0)
        }
        view.present(alertController, animated: true)
    }
    
    func createErrorAlert(view: UIViewController) {
        let alertController = UIAlertController(title: "Не удалось получить данные", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { action in
            UIBlockingProgressHUD.dismiss()
            view.dismiss(animated: true)
        }
        let repeatAction = UIAlertAction(title: "Повторить", style: .default) { action in
            self.statisticService.fetchNextPage()
        }
        [cancelAction, repeatAction].forEach {
            alertController.addAction($0)
        }
        view.present(alertController, animated: true)
    }
    
    func sortUsers() {
        //сортировка реализована таким способом, потому что с сервера получить ее в отсортированном виде для дефолтного отображения невозможно по словам наставника, из за того что ее не починили. по итогу имеем что люди с рейтингом выше при прокрутке подставляются в начало
        if let value = UserDefaults.standard.string(forKey: "sortBy") {
            self.objects = self.statisticService.users
            self.sortRating(sort: value)
        }   else {
            self.objects = self.statisticService.users.sorted { $0.nfts.count > $1.nfts.count }
        }
    }
}
