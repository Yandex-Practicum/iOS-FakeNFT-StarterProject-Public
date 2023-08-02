//
//  Types.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 01.08.2023.
//

import Foundation

typealias EventHandler<T> = (T) -> Void
typealias ExecutionBlock = () -> Void
typealias ResultHandler<T> = (Result<T, Error>) -> Void
