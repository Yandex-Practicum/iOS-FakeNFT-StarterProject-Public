import UIKit

final class EditProfileViewController: UIViewController {
    private let viewModel: ProfileViewModelProtocol

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = EditProfileView(frame: .zero, viewController: self, viewModel: viewModel)
    }

    init(viewModel: ProfileViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
