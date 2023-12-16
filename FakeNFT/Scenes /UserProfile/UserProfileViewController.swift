//
// Created by Андрей Парамонов on 16.12.2023.
//

import UIKit

final class UserProfileViewController: UIViewController {
    private let viewModel: UserProfileViewModel

    init(viewModel: UserProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
