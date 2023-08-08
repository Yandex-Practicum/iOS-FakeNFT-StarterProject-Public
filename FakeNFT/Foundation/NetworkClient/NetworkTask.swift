import Foundation

protocol NetworkTask {
    func cancel()
}

struct DefaultNetworkTask: NetworkTask {
    let dataTask: URLSessionDataTask

    func cancel() {
        dataTask.cancel()
    }
}

extension NetworkTask? {
    var isTaskRunning: Bool {
        self != nil
    }
}
