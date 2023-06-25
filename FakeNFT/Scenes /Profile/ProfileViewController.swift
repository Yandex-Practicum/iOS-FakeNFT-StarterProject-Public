import UIKit

final class ProfileViewController: UIViewController {

    private lazy var editButton = UIBarButtonItem(
        image: UIImage.Icons.edit,
        style: .plain,
        target: self,
        action: #selector(didTapSortButton)
    )
        
    private var viewModel: ProfileViewModel?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ProfileViewModel(viewController: self)
        bind()
//        viewModel?.viewDidLoad()
        
        
        
        setupView()
    }
        
    @objc
    private func didTapSortButton() {
    }
        
    private func bind() {
        if let viewModel = viewModel {
            viewModel.onChange = { [weak self] in
                //            self?.summaryView.configure(with: viewModel.summaryInfo)
            }
        }
    }

    func setupView() {
        self.view = ProfileView()
        setupNavBar()
    }

    func setupNavBar() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = editButton
    }
}
