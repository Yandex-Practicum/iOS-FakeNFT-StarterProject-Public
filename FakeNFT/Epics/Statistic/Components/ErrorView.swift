//
//  ErrorView.swift
//  FakeNFT
//
//  Created by Александр Зиновьев on 30.07.2023.
//

import UIKit
import SnapKit

final class ErrorView: UIView {
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = NSLocalizedString("failedToLoadData", comment: "")
        label.numberOfLines = 0
        return label
    }()

    private let errorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        let configuration = UIImage.SymbolConfiguration(scale: .large)
        imageView.image = UIImage(systemName: "eyes")?.withConfiguration(configuration)
        return imageView
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    private func setupUI() {
        isHidden = true
        alpha = 0

        addSubview(containerView)
        containerView.addSubview(stackView)
        stackView.addArrangedSubview(errorImageView)
        stackView.addArrangedSubview(errorLabel)

        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func hideErrorView() {
        UIView.animate(withDuration: 0.3) {
            self.isHidden = true
            self.alpha = 0
        }
    }

    func showErrorView() {
        UIView.animate(withDuration: 0.3) {
            self.isHidden = false
            self.alpha = 1
        }
    }
}
