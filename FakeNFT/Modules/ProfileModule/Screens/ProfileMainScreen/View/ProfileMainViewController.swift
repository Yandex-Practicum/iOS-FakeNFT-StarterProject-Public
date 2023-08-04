//
//  ProfileMainViewController.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 15.07.2023.
//

import UIKit
import Combine

protocol ProfileMainCoordinatableProtocol {
    var onEdit: (() -> Void)? { get set }
    var onMyNfts: (([String]) -> Void)? { get set }
    var onLiked: (() -> Void)? { get set }
    var onError: ((Error) -> Void)? { get set }
}

protocol Reloadable {
    func reload()
}

final class ProfileMainViewController: UIViewController, ProfileMainCoordinatableProtocol, Reloadable {

    var onEdit: (() -> Void)?
    var onMyNfts: (([String]) -> Void)?
    var onLiked: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    var cancellables = Set<AnyCancellable>()
    
    private let viewModel: ProfileMainViewModel
    private let dataSource: GenericTableViewDataSourceProtocol
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ProfileMainTableViewCell.self, forCellReuseIdentifier: ProfileMainTableViewCell.defaultReuseIdentifier)
        tableView.delegate = self
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var profileImageView: ProfileImageView = {
        let imageView = ProfileImageView(frame: .zero)
        return imageView
    }()
    
    private lazy var authorNameLabel: CustomLabel = {
        let label = CustomLabel(size: 22, weight: .bold, color: .ypBlack)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var authorImageAndNameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.addArrangedSubview(profileImageView)
        stackView.addArrangedSubview(authorNameLabel)
        return stackView
    }()
    
    private lazy var descriptionTextView: DescriptionTextView = {
        let textView = DescriptionTextView(frame: .zero, textContainer: nil)
        return textView
    }()
    
    private lazy var loadingView: CustomAnimatedView = {
        let view = CustomAnimatedView(frame: .zero)
        return view
    }()
    
    private lazy var authorWebsiteLabel: CustomLabel = {
        let label = CustomLabel(size: 15, weight: .regular, color: .universalBlue)
        let attrString = NSMutableAttributedString()
        let attrText = NSMutableAttributedString(string: label.text ?? "")
        let range = NSRange(location: 0, length: attrText.length)
        attrText.addAttribute(.link, value: label.text ?? "", range: range)
        label.attributedText = attrString
        
        return label
    }()
    
    private lazy var authorMainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.addArrangedSubview(authorImageAndNameStackView)
        stackView.addArrangedSubview(descriptionTextView)
        stackView.addArrangedSubview(authorWebsiteLabel)
        return stackView
    }()
    
    // MARK: Init
    init(viewModel: ProfileMainViewModel, dataSource: GenericTableViewDataSourceProtocol) {
        self.viewModel = viewModel
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupConstraints()
        reload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createDataSource()
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancellables.forEach({ $0.cancel() })
        cancellables.removeAll()
    }
    
    // MARK: Load
    func reload() {
        viewModel.loadUser()
    }
    
    // MARK: Bind
    private func bind() {
        viewModel.$profile
            .receive(on: DispatchQueue.main)
            .sink { [weak self] profile in
                self?.updateUI(with: profile)
            }
            .store(in: &cancellables)
        
        viewModel.$profileData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] profileModel in
                self?.updateDataSource(with: profileModel)
            }
            .store(in: &cancellables)
        
        viewModel.$profileMainError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.catchError(error)
            }
            .store(in: &cancellables)
        
        viewModel.$requestResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] requestResult in
                self?.showOrHideAnimation(for: requestResult)
            }
            .store(in: &cancellables)
    }
    
    // MARK: UpdateUI
    private func updateUI(with profile: Profile?) {
        guard let profile else { return }
        authorNameLabel.text = profile.name
        updateCoverImage(for: profile)
        descriptionTextView.text = profile.description
        authorWebsiteLabel.addLink(text: K.Titles.authorWebsite, link: profile.website)
    }
    
    func updateCoverImage(for profile: Profile) {
        guard
            let encodedStringUrl = profile.avatar.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed
            ),
            let url = URL(string: encodedStringUrl)
        else {
            return
        }
        
        profileImageView.setImage(from: url)
    }

}

// MARK: - Ext Animation
private extension ProfileMainViewController {
    func showOrHideAnimation(for requestResult: RequestResult?) {
        guard let requestResult
        else {
            loadingView.stopAnimation()
            return
        }
        
        loadingView.result = requestResult
        loadingView.startAnimation()
    }
}

// MARK: - Ext DataSource
private extension ProfileMainViewController {
    func createDataSource() {
        dataSource.createDataSource(for: tableView, with: viewModel.profileData)
    }
    
    func updateDataSource(with rows: [ProfileModel]) {
        dataSource.updateTableView(with: rows)
    }
}

// MARK: - Ext TableViewDelegate
extension ProfileMainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        dataSource.getRowHeight(.profile)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        switch indexPath.row {
        case 0:
            goToMyNfts()
        case 1:
            goToLikedNfts()
        default:
            print(indexPath)
        }
    }
}

// MARK: - Ext Navigation
private extension ProfileMainViewController {
    func goToMyNfts() {
        guard let nfts = viewModel.profile?.nfts else { return }
        onMyNfts?(nfts)
    }
    
    func goToLikedNfts() {
        onLiked?()
    }
}

// MARK: Catch error
private extension ProfileMainViewController {
    func catchError(_ error: Error?) {
        guard let error else { return }
        onError?(error)
    }
}

// MARK: - Ext Constraints
private extension ProfileMainViewController {
    func setupConstraints() {
        setupMainStackView()
        setupTableView()
        setupLoadingView()
    }
    
    func setupMainStackView() {
        view.addSubview(authorMainStackView)
        authorMainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            authorMainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            authorMainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            authorMainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: authorMainStackView.bottomAnchor, constant: 40),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupLoadingView() {
        view.addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.heightAnchor.constraint(equalToConstant: 50),
            loadingView.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
}
