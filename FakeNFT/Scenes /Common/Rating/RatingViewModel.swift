//
//  RatingViewModel.swift
//  FakeNFT
//
//  Created by Natasha Trufanova on 25/06/2024.
//

import Combine
import Foundation

final class RatingViewModel: ObservableObject {
    @Published var rating: Int = 0
    
    init(rating: Int = 0) {
        self.rating = rating
    }
    
    func setRating(_ rating: Int) {
        self.rating = rating
    }
}
