import UIKit

final class DeleteView: UIView {
    
    private let viewModel: CartViewModel
    init(viewModel: CartViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configureView()
    }
    var onCancelButtonTapped: (() -> Void)?
    var onDeleteButtonTapped: (() -> Void)?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private let bluredBackgroundView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView(effect: effect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AppIcon")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nftDeleteConfirmLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Regular.size13
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Вы уверены, что хотите \nудалить объект из корзины?"
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nftDeleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Удалить", for: .normal)
        button.setTitleColor(UIColor.Universal.red, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.layer.backgroundColor = UIColor.Universal.black?.cgColor
        button.addTarget(self,
                         action: #selector(deleteButtonTapped),
                         for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var nftCancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Вернуться", for: .normal)
        button.setTitleColor(UIColor.Universal.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.layer.backgroundColor = UIColor.Universal.black?.cgColor
        button.addTarget(self,
                         action: #selector(cancelButtonTapped),
                         for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private func configureView() {
        addSubviews()
        setConstraints()
    }
    
    private func addSubviews() {
        addSubview(bluredBackgroundView)
        addSubview(nftDeleteConfirmLabel)
        addSubview(nftImageView)
        addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(nftDeleteButton)
        buttonStackView.addArrangedSubview(nftCancelButton)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            bluredBackgroundView.topAnchor.constraint(equalTo: topAnchor),
            bluredBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bluredBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bluredBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            nftImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            nftImageView.topAnchor.constraint(equalTo: topAnchor, constant: 244),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftDeleteConfirmLabel.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 12),
            nftDeleteConfirmLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nftDeleteConfirmLabel.widthAnchor.constraint(equalToConstant: 180),
            buttonStackView.topAnchor.constraint(equalTo: nftDeleteConfirmLabel.bottomAnchor, constant: 20),
            buttonStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            nftCancelButton.widthAnchor.constraint(equalToConstant: 127),
            nftDeleteButton.widthAnchor.constraint(equalToConstant: 127),
            nftCancelButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func showDeleteView(atIndex index: Int) {
        bluredBackgroundView.isHidden = false
        nftImageView.kf.setImage(with: viewModel.cartModels[index].images.first)
        nftImageView.isHidden = false
        nftDeleteConfirmLabel.isHidden = false
        buttonStackView.isHidden = false
        nftCancelButton.isHidden = false
        nftDeleteButton.isHidden = false
    }
    
    @objc func deleteButtonTapped() {
        onDeleteButtonTapped?()
    }
    @objc func cancelButtonTapped() {
        onCancelButtonTapped?()
    }
    func removeDeleteView() {
        bluredBackgroundView.isHidden = true
        nftImageView.isHidden = true
        nftDeleteButton.isHidden = true
        nftCancelButton.isHidden = true
        nftDeleteConfirmLabel.isHidden = true
    }
}
