//
//  StatisticPresenter.swift
//  FakeNFT
//
//  Created by Сергей on 23.04.2024.
//

import Foundation
import Alamofire

protocol StatisticsViewPresenterDelegate: AnyObject {
    func set(person: Person)
}

protocol StatisticPresenterProtocol: AnyObject {
    var objects: [Person] { get set }
    func getStatistic(complition: @escaping () -> Void)
}

final class StatisticsPresenter: StatisticPresenterProtocol {
    
    var objects: [Person] = []
    
    func getStatistic(complition: @escaping () -> Void) {
        let headers: HTTPHeaders = [
            NetworkConstants.acceptKey : NetworkConstants.acceptValue,
            NetworkConstants.tokenKey : NetworkConstants.tokenValue
        ]
        
        AF.request("\(NetworkConstants.baseURL)/api/v1/users?page=2&size=10", headers: headers).responseDecodable(of: [Person].self) { response in
            switch response.result {
            case .success(let object):
                self.objects = object
                complition()
            case .failure(let error):
                print(error)
                
            }
        }
    }
}


