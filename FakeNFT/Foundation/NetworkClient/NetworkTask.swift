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

extension DefaultNetworkTask? {
    var isRunning: Bool {
        guard let self = self else { return false }
        return self.dataTask.state == .running
    }
}
