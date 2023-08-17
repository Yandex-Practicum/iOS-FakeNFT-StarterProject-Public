import Foundation

public typealias ResultHandler<T> = (Result<T, Error>) -> Void

public typealias LoadingCompletionBlock<T> = (T) -> Void
public typealias LoadingFailureCompletionBlock = (Error) -> Void

public typealias ActionCallback<T> = (T) -> Void
