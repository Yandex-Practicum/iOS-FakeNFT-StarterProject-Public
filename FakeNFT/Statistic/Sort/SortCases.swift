//
//  SortCases.swift
//  FakeNFT
//
//  Created by Ilya Nikitash on 3/15/25.
//
import Foundation

enum SortCases: String, CaseIterable {
    case name
    case rating
    
    var title: String {
        switch self {
        case .name: "По имени"
        case .rating: "По рейтингу"
        }
    }
}
