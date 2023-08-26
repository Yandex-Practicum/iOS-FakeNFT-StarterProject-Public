//
//  UserCardViewModel.swift
//  FakeNFT
//
//  Created by Александр Зиновьев on 05.08.2023.
//

import Combine

protocol UserCardViewModel {
    var sections: CurrentValueSubject<[UserCardViewModelImpl.SectionType], Never> { get }
}

final class UserCardViewModelImpl: UserCardViewModel {
    var sections: CurrentValueSubject<[UserCardViewModelImpl.SectionType], Never> = .init([])

    // Private
    private let user: User

    init(user: User) {
        self.user = user
        setUpSections()
    }

    private func setUpSections() {
        sections.value = [
            .user(viewModel: .init(user: user)),
            .site,
            .collection(
                viewModels: [
                    .init(nfts: user.nfts)
                ]
            )
        ]
    }
}

extension UserCardViewModelImpl {
    enum SectionType: Hashable {
        case user(viewModel: UserCardCellViewModel)
        case site
        case collection(viewModels: [NFTCollectionCellViewModel])
    }

    struct ItemIdentifier: Hashable {
        let section: SectionType
        let index: Int
    }
}
