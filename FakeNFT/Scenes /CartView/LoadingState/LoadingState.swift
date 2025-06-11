//
//  LoadingState.swift
//  FakeNFT
//
//  Created by Max on 09.06.2025.
//

enum LoadingState<T> {
    case loading
    case empty
    case loaded(T)
    case error(String)
}
