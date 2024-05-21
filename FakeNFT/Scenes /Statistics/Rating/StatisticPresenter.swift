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
    var newObjects: [Person] { get set }
    func viewDidLoad()
    func getStatistic()
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
    var newObjects: [Person] = []

    func viewDidLoad() {
        observeAnimate()
    }

    func sortRating(sort value: SortingType) {

        switch value {
        case .name:
            let sortedObjects = objects.sorted { $0.name < $1.name }
            objects = sortedObjects
        case .rating:
            let sortedObjects = objects.sorted { $0.nfts.count > $1.nfts.count }
            objects = sortedObjects
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
       getStatistic()
    }

    func createSortAlert(view: UIViewController, collection: UICollectionView) {
        let alertController =  UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        let nameAction = UIAlertAction(title: "По имени", style: .default) { _ in
            UserDefaults.standard.set("Name", forKey: "sortBy")
            self.sortRating(sort: .name)
            collection.reloadData()
        }
        let ratingAction = UIAlertAction(title: "По рейтингу", style: .default) { _ in
            UserDefaults.standard.set("Rating", forKey: "sortBy")
            self.sortRating(sort: .rating)
            collection.reloadData()

        }

        let closeAction = UIAlertAction(title: "Закрыть", style: .cancel) { _ in
            view.dismiss(animated: true)
        }

        [nameAction, ratingAction, closeAction].forEach {
            alertController.addAction($0)
        }
        view.present(alertController, animated: true)
    }

    func createErrorAlert(view: UIViewController) {
        let alertController = UIAlertController(title: "Не удалось получить данные", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { _ in
            UIBlockingProgressHUD.dismiss()
            view.dismiss(animated: true)
        }
        let repeatAction = UIAlertAction(title: "Повторить", style: .default) { _ in
            self.getStatistic()
        }
        [cancelAction, repeatAction].forEach {
            alertController.addAction($0)
        }
        view.present(alertController, animated: true)
    }

    func sortUsers() {
        // сортировка реализована таким способом, потому что с сервера получить ее в отсортированном виде для дефолтного отображения невозможно по словам наставника, из за того что ее не починили. по итогу имеем что люди с рейтингом выше при прокрутке подставляются в начало
        if let value = UserDefaults.standard.string(forKey: "sortBy"), let stringValue = SortingType(rawValue: value) {
            self.objects = self.newObjects
            self.sortRating(sort: stringValue)
        } else {
            self.objects = self.newObjects.sorted { $0.nfts.count > $1.nfts.count }
        }
    }

    func getStatistic() {
        statisticService.fetchNextPage { result in
            switch result {
            case .success(let user):
                self.newObjects.append(contentsOf: user)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

enum SortingType: String {
    case name = "Name"
    case rating = "Rating"

}
