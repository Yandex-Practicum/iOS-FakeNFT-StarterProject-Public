//
// Created by Андрей Парамонов on 17.12.2023.
//

import WebKit

protocol WebViewViewModel {
    var urlRequest: URLRequest { get }
    var progressObservable: Observable<Float> { get }
    var progressBarHiddenObservable: Observable<Bool> { get }

    func viewDidLoad()
    func didUpdateProgressValue(_ progress: Double)
}

final class WebViewViewModelImpl: WebViewViewModel {
    private let url: URL

    @Observable
    private var progress: Float = 0

    @Observable
    private var progressBarHidden: Bool = false

    init(url: URL) {
        self.url = url
    }

    var progressObservable: Observable<Float> {
        $progress
    }

    var progressBarHiddenObservable: Observable<Bool> {
        $progressBarHidden
    }

    var urlRequest: URLRequest {
        URLRequest(url: url)
    }

    func viewDidLoad() {
        cleanWebData()
    }

    func didUpdateProgressValue(_ progress: Double) {
        self.progress = Float(progress)
        progressBarHidden = progress == 1
    }

    private func cleanWebData() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                dataStore.removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}
