import UIKit

final class ProfileViewController: UIViewController {
    
    private lazy var editButton = UIBarButtonItem(
        image: UIImage.Icons.edit,
        style: .plain,
        target: self,
        action: #selector(didTapEditButton)
    )
    
    private var viewModel: ProfileViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ProfileViewModel(viewController: self)
        bind()
        setupView()
    }
    
    @objc
    private func didTapEditButton() {
        let editProfileViewController = EditProfileViewController()
        editProfileViewController.modalPresentationStyle = .popover
        self.present(editProfileViewController, animated: true)
    }
    
    private func bind() {
        if let viewModel = viewModel {
            viewModel.onChange = { [weak self] in
                let view = self?.view as? ProfileView
                view?.updateViews(
                    userImageURL: viewModel.userImageURL,
                    userName: viewModel.userName,
                    description: viewModel.description,
                    website: viewModel.website,
                    nftCount: "(\(String(viewModel.nfts?.count ?? 0)))",
                    likesCount: "(\(String(viewModel.likes?.count ?? 0)))"
                )
            }
        }
    }
    
    func setupView() {
        self.view = ProfileView(frame: .zero, viewController: self)
        setupNavBar()
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = editButton
    }
}
