//
//  Types.swift
//  FakeNFT
//
//  Created by Дмитрий Никишов on 01.08.2023.
//

import Foundation

typealias EventHandler<T> = (T) -> Void
typealias ExecutionBlock = () -> Void
public typealias ResultHandler<T> = (Result<T, Error>) -> Void

public typealias LoadingCompletionBlock<T> = (T) -> Void
public typealias LoadingFailureCompletionBlock = (Error) -> Void

public typealias ActionCallback<T> = (T) -> Void
