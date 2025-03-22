//
//  ProfileViewController.swift
//  FakeNFT
//
//  Created by Давид Бекоев on 17.03.2025.
//
//

import UIKit

final class ProfileViewController: UIViewController, ErrorView {
    // MARK: - Section
    
    private enum ProfileRoutingTableViewSection: Hashable {
        case main
    }
    
    // MARK: - Item
    
    private enum ProfileRoutingTableViewItem: Hashable {
        case myNft(Int)
        case favourites(Int)
        case about
        
        var title: String {
            switch self {
            case .myNft(let num):
                return "\("Мои Нфт") (\(num))"
            case .favourites(let num):
                return "\("Избранные Нфт") (\(num))"
            case .about:
                return "\("О разработчике")"
            }
        }
    }
    
    // MARK: - Type Aliases
    
    private typealias DataSource = UITableViewDiffableDataSource<ProfileRoutingTableViewSection, ProfileRoutingTableViewItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<ProfileRoutingTableViewSection, ProfileRoutingTableViewItem>
    
    // MARK: - Constants
    private let viewModel: ProfileViewModel
    private let profileRoutingCellHeight = 70.0
    private let numberOfCells = 3
    private let activityIndicatorViewSize = CGSize(width: 25.0, height: 25.0)
    
    // MARK: - Private Properties
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var editBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(named:"Edit"),
            style: .done,
            target: self,
            action: #selector(editButtonDidTap)
        )
        button.tintColor = .black
        return button
    }()
    
    private lazy var profileCardView: ProfileCardView = {
        let profileCardView = ProfileCardView()
        profileCardView.translatesAutoresizingMaskIntoConstraints = false
        return profileCardView
    }()
    
    private lazy var linkButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .caption1
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(linkButtonDidTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var profileRoutingTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var dataSource: DataSource = {
        DataSource(tableView: profileRoutingTableView) { tableView, indexPath, routeItem in
            let cell = UITableViewCell()
            
            if #available(iOS 14.0, *) {
                var content = UIListContentConfiguration.cell()
                content.text = routeItem.title
                content.textProperties.font = .bodyBold
                content.textProperties.color = .black
                cell.contentConfiguration = content
            } else {
                cell.textLabel?.text = routeItem.title
                cell.textLabel?.font = .bodyBold
                cell.textLabel?.textColor = .black
            }
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
            cell.selectionStyle = .none
            cell.backgroundColor = .white
            cell.setAccessoryView(with: .black)
            return cell
        }
    }()
    
    // MARK: - Init
    
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        setupDataBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startLoading()
        viewModel.viewWillAppear()
        
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(activityIndicatorView)
        view.addSubview(profileCardView)
        view.addSubview(linkButton)
        view.addSubview(profileRoutingTableView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            profileCardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            linkButton.topAnchor.constraint(equalTo: profileCardView.bottomAnchor, constant: 8),
            linkButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            profileRoutingTableView.topAnchor.constraint(equalTo: linkButton.bottomAnchor, constant: 40),
            profileRoutingTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileRoutingTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileRoutingTableView.heightAnchor.constraint(equalToConstant: profileRoutingCellHeight * CGFloat(numberOfCells)),
            
            activityIndicatorView.heightAnchor.constraint(equalToConstant: activityIndicatorViewSize.height),
            activityIndicatorView.widthAnchor.constraint(equalToConstant: activityIndicatorViewSize.width),
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupDataBinding() {
        viewModel.profile.bind { [weak self] profile in
            guard let profile else { return }
            self?.stopLoading()
            if let url = URL(string: profile.avatar) {
                self?.profileCardView.setAvatarImage(url: url)
            }
            self?.profileCardView.setNameText(profile.name)
            self?.profileCardView.setDescriptionText(profile.description)
            self?.linkButton.setTitle(profile.website, for: .normal)
            self?.applySnapshot(myNftsNumber: profile.nfts.count,
                                favouritesNumber: profile.likes.count)
        }
        
        viewModel.errorModel.bind { [weak self] errorModel in
            guard let errorModel else { return }
            self?.showError(errorModel)
        }
        
    }
    
    private func startLoading() {
        navigationItem.rightBarButtonItem = nil
        profileCardView.isHidden = true
        linkButton.isHidden = true
        profileRoutingTableView.isHidden = true
        activityIndicatorView.startAnimating()
    }
    
    private func stopLoading() {
        navigationItem.rightBarButtonItem = editBarButtonItem
        activityIndicatorView.stopAnimating()
        profileCardView.isHidden = false
        linkButton.isHidden = false
        profileRoutingTableView.isHidden = false
    }
    
    private func applySnapshot(myNftsNumber: Int, favouritesNumber: Int) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems([.myNft(myNftsNumber), .favourites(favouritesNumber), .about])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    // MARK: - Actions
    
    
    @objc private func editButtonDidTap() {
        viewModel.editButtonDidTap()
    }
    
    
    @objc private func linkButtonDidTap() {
        viewModel.linkButtonDidTap()
    }
}
// MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        profileRoutingCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let routingItem = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        switch routingItem {
        case .myNft(_):
            viewModel.myNftsCellDidSelect()
        case .favourites(_):
            viewModel.favouritesCellDidSelect()
        case .about:
            viewModel.aboutDeveloperCellDidSelect()
        }
    }
}
