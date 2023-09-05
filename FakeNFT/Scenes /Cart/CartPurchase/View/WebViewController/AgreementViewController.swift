import UIKit
import SafariServices

final class AgreementWebViewController: UIViewController {
    
    private var safariViewController: SFSafariViewController?
    
    private let request: URLRequest
    
    init(request: URLRequest) {
        self.request = request
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentSafariViewController()
    }
    
    func presentSafariViewController() {
        guard let url = request.url else { return }
        safariViewController = SFSafariViewController(url: url)
        safariViewController?.modalPresentationStyle = .fullScreen
        if let safariVC = safariViewController {
            safariVC.delegate = self
            present(safariVC, animated: true)
        }
    }
}

extension AgreementWebViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
}
