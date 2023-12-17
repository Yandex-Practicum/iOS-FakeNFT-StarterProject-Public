//
// Created by Андрей Парамонов on 17.12.2023.
//

import WebKit

protocol WebViewViewModel {
    var urlRequest: URLRequest { get }
    func viewDidLoad()
    func didUpdateProgressValue(_ progress: Double)

    var progressObservable: Observable<Float> { get }
    var progressBarHiddenObservable: Observable<Bool> { get }
}

final class WebViewViewModelImpl: WebViewViewModel {
    @Observable
    private var progress: Float = 0

    @Observable
    private var progressBarHidden: Bool = false

    private let url: URL

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

    private func cleanWebData() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                dataStore.removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }

    func didUpdateProgressValue(_ progress: Double) {
        self.progress = Float(progress)
        progressBarHidden = progress == 1
    }
}
