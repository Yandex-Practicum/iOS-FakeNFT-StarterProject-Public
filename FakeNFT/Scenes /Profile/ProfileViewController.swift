import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    private var viewModel: ProfileViewModel
    
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
        
        bind()
        setupView()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.getProfileData()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    
    required init?(coder aDecoder: NSCoder) {
        self.viewModel = ProfileViewModel()
       super.init(coder: aDecoder)
    }
    
    // MARK: - Methods
    @objc
    private func didTapEditButton() {
        let editProfileViewController = EditProfileViewController(viewModel: viewModel)
        editProfileViewController.modalPresentationStyle = .popover
        self.present(editProfileViewController, animated: true)
    }
    
    private func bind() {
        viewModel.onChange = { [weak self] in
            self?.setupView()
            let view = self?.view as? ProfileView
            view?.updateViews(
                avatarURL: self?.viewModel.avatarURL,
                userName: self?.viewModel.name,
                description: self?.viewModel.description,
                website: self?.viewModel.website,
                nftCount: "(\(String(self?.viewModel.nfts?.count ?? 0)))",
                likesCount: "(\(String(self?.viewModel.likes?.count ?? 0)))"
            )
        }
        
        viewModel.onError = { [weak self] in
            self?.view = NoInternetView()
            self?.navigationController?.navigationBar.isHidden = true
        }
    }
    
    func setupView() {
        self.view = ProfileView(frame: .zero, viewModel: self.viewModel, viewController: self)
        setupNavBar()
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = editButton
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func getNftIDsFromViewModel() -> [String] {
        guard let nfts = viewModel.nfts else { return [] }
        return nfts
    }
}

extension ProfileViewController: UIGestureRecognizerDelegate {}
