import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    private var viewModel: ProfileViewModel?
    
    //MARK: - Layout elements
    private lazy var editButton = UIBarButtonItem(
        image: UIImage.Icons.edit,
        style: .plain,
        target: self,
        action: #selector(didTapEditButton)
    )
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ProfileViewModel(viewController: self)
        bind()
        setupView()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    // MARK: - Methods
    @objc
    private func didTapEditButton() {
        let editProfileViewController = EditProfileViewController()
        editProfileViewController.viewModel = viewModel
        editProfileViewController.modalPresentationStyle = .popover
        self.present(editProfileViewController, animated: true)
    }
    
    private func bind() {
        if let viewModel = viewModel {
            viewModel.onChange = { [weak self] in
                let view = self?.view as? ProfileView
                view?.updateViews(
                    avatarURL: viewModel.avatarURL,
                    userName: viewModel.name,
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
    
    func getNftIDsFromViewModel() -> [String] {
        guard let nfts = viewModel?.nfts else { return [] }
        return nfts
    }
}

extension ProfileViewController: UIGestureRecognizerDelegate {}
