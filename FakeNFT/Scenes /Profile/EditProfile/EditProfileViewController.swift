//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Dinara on 24.03.2024.
//

import SnapKit
import UIKit

// MARK: - EditProfileViewController Class
final class EditProfileViewController: UIViewController {
    // MARK: - Public Properties
    var presenter: ProfilePresenterProtocol

    // MARK: - UI
    private lazy var editProfileView: EditProfileView = {
        let view = EditProfileView(
            frame: .zero,
            viewController: self,
            presenter: presenter
        )
        return view
    }()

    // MARK: - Init
    init(
        presenter: ProfilePresenterProtocol
    ) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
}

private extension EditProfileViewController {
    func setupViews() {
        view.addSubview(editProfileView)
    }

    func setupConstraints() {
        editProfileView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
