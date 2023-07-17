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
}

final class ProfileMainViewController: UIViewController, ProfileMainCoordinatableProtocol {

    var onEdit: (() -> Void)?
    var cancellables = Set<AnyCancellable>()
    
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
    
    private let viewModel: ProfileMainViewModel
    private let dataSource: GenericTableViewDataSourceProtocol
    
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
        load()
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
    private func load() {
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
    }
    
    // MARK: DataSource
    private func createDataSource() {
        dataSource.createDataSource(for: tableView, with: viewModel.profileData)
    }
    
    private func updateDataSource(with rows: [ProfileModel]) {
        dataSource.updateTableView(with: rows)
    }
    
    // MARK: UpdateUI
    private func updateUI(with profile: Profile?) {
        guard let profile else { return }
        authorNameLabel.text = profile.name
        updateCoverImage(for: profile)
        descriptionTextView.text = profile.description
        authorWebsiteLabel.text = profile.website
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

// MARK: - Ext TableViewDelegate
extension ProfileMainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        dataSource.getCartRowHeight(for: tableView, in: .profile)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: - Ext Constraints
private extension ProfileMainViewController {
    func setupConstraints() {
        setupMainStackView()
        setupTableView()
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
}
