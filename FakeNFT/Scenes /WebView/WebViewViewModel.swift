//
// Created by Андрей Парамонов on 17.12.2023.
//

import WebKit

protocol WebViewViewModel {
    var request: URLRequest { get }
    var progressObservable: Observable<Float> { get }
    var progressBarHiddenObservable: Observable<Bool> { get }

    func viewDidLoad()
    func didUpdateProgressValue(_ progress: Double)
}

final class WebViewViewModelImpl: WebViewViewModel {
    let request: URLRequest

    @Observable
    private var progress: Float = 0

    @Observable
    private var progressBarHidden: Bool = false

    init(request: URLRequest) {
        self.request = request
    }

    var progressObservable: Observable<Float> {
        $progress
    }

    var progressBarHiddenObservable: Observable<Bool> {
        $progressBarHidden
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
