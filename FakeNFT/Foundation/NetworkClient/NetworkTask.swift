import Foundation

protocol NetworkTask {
    func cancel()
}

final class DefaultNetworkTask: NetworkTask {
    let dataTask: URLSessionDataTask

    init(dataTask: URLSessionDataTask) {
        self.dataTask = dataTask
    }

    func cancel() {
        dataTask.cancel()
    }
}

extension NetworkTask? {
    var isTaskRunning: Bool {
        self != nil
    }
}
