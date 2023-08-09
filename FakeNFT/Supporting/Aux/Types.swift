//
//  Types.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 04.08.2023.
//

import Foundation

typealias ResultHandler<T> = (Result<T, Error>) -> Void

typealias LoadingCompletionBlock<ViewState> = (ViewState) -> Void
typealias LoadingFailureCompletionBlock = (Error) -> Void

typealias ActionCallback<T> = (T) -> Void
