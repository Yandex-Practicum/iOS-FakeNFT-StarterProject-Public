//
//  UserCardViewController.swift
//  FakeNFT
//
//  Created by Александр Зиновьев on 05.08.2023.
//

import UIKit
import Combine
import SnapKit

final class UserCardViewController: NiblessViewController {
    typealias SectionType = UserCardViewModelImpl.SectionType
    typealias ItemIdentifier = UserCardViewModelImpl.ItemIdentifier

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.contentInset.top = 20
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .ypWhite
        view.delegate = self
        view.refreshControl = refreshControl
        view.register(UserCardCellView.self)
        view.register(SiteCellView.self)
        view.register(CollectionCellView.self)
        return view
    }()

    private lazy var dataSource: UICollectionViewDiffableDataSource<SectionType, ItemIdentifier> = {
        return .init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier.section {
            case .user(viewModel: let viewModel):
                let cell: UserCardCellView = collectionView.dequeueReusableCell(indexPath: indexPath)
                cell.configure(with: viewModel)
                return cell

            case .site:
                let cell: SiteCellView = collectionView.dequeueReusableCell(indexPath: indexPath)
                return cell

            case .collection(viewModels: let viewModels):
                let cell: CollectionCellView = collectionView.dequeueReusableCell(indexPath: indexPath)
                cell.configure(with: viewModels[indexPath.item])
                return cell
            }
        }
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = .ypBlack
        control.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        return control
    }()

    private var cancellables = Set<AnyCancellable>()
    private let viewModel: UserCardViewModel

    init(viewModel: UserCardViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        addConstraints()
        createTabTabItem()
        bind(to: viewModel)
    }

    // MARK: - @objc methods
    @objc private func pullToRefresh() { }

    @objc private func backButtonTap() {
        navigationController?.popViewController(animated: true)
    }
}

extension UserCardViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
            feedbackGenerator.impactOccurred()
        }
    }
}

// MARK: Data
private extension UserCardViewController {
    func bind(to viewModel: UserCardViewModel) {
        viewModel.sections
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sections in
                self?.updateSnapshot(with: sections)
            }
            .store(in: &cancellables)
    }

    func updateSnapshot(with sections: [SectionType]) {
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, ItemIdentifier>()
        snapshot.appendSections(sections)

        for section in sections {
            switch section {
            case .user:
                snapshot.appendItems([ItemIdentifier(section: section, index: 0)], toSection: section)

            case .site:
                snapshot.appendItems([ItemIdentifier(section: section, index: 1)], toSection: section)

            case .collection(let viewModels):
                let collection = viewModels
                    .enumerated()
                    .map { ItemIdentifier(section: section, index: $0.offset) }

                snapshot.appendItems(collection, toSection: section)
            }
        }

        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// UI
private extension UserCardViewController {
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            self.createSection(for: sectionIndex)
        }

        return layout
    }

    func createSection(for sectionIndex: Int) -> NSCollectionLayoutSection {
        let sectionType = viewModel.sections.value

        switch sectionType[sectionIndex] {
        case .user:
            return createSection(height: 162, bottomPadding: 28)

        case .site:
            return createSection(height: 40, bottomPadding: 40)

        case .collection:
            return createSection(height: 54, bottomPadding: 0)
        }
    }

    func createSection(height: CGFloat, bottomPadding: CGFloat, count: Int = 1) -> NSCollectionLayoutSection {
        // Item
        let item: NSCollectionLayoutItem = .create(
            withWidth: .fractionalWidth(1.0),
            height: .estimated(height),
            insets: .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        )

        // Group
        let group = NSCollectionLayoutGroup.create(
            horizontalGroupWithWidth: .fractionalWidth(1.0),
            height: .estimated(height),
            items: [item]
        )

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 0, bottom: bottomPadding, trailing: 0)

        return section
    }

    func createTabTabItem() {
        let image = UIImage(systemName: "chevron.backward")?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(.ypBlack)

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(backButtonTap)
        )
    }

    func addSubviews() {
        view.addSubview(collectionView)
        view.backgroundColor = .ypWhite
    }

    func addConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
    }
}
