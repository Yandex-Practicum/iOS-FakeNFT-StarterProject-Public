import UIKit

protocol MyNFTCellView: AnyObject, LoadingView {
    var presenter: MyNFTCellPresenterProtocol? { get set }
    func configereCell()
    func setImage(data: Data)
    func enabledLikeButton()
    func unenabledLikeButton()
    func updateLikeImage()
}

final class MyNFTCell: UITableViewCell, MyNFTCellView {
    
    static let cellID = "cellID"
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SFProText-Bold", size: 17)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var autorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SFProText-Regular", size: 12)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var ratingView: RatingView = {
        let view = RatingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var centralStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    internal lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var priceTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SFProText-Regular", size: 13)
        label.text = NSLocalizedString("price", comment: "")
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SFProText-Bold", size: 17)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var priceStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 2
        return stack
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 20
        return stack
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(likeButtonDidTapped), for: .touchUpInside)
        return button
    }()

    var presenter: MyNFTCellPresenterProtocol?
    
    override func prepareForReuse() {
        iconImageView.image = nil
    }
    
    func configereCell() {
        selectionStyle = .none
        addSubviews()
        
        nameLabel.text = presenter?.nft?.name
        autorLabel.text = "от John Doe" // TODO: Поменять когда сервер начнет отдавать нормальные данные
        ratingView.setRating(rating: presenter?.nft?.rating ?? 0 / 2)
        priceLabel.text = "\(presenter?.nft?.price ?? 0) ETN"

        updateLikeImage()
        presenter?.loadImage()
    }
    
    func setImage(data: Data) {
        iconImageView.image = UIImage(data: data)
    }
    
    @objc func likeButtonDidTapped() {
        presenter?.likeButtonDidTapped()
    }
    
    func enabledLikeButton() {
        likeButton.isEnabled = true
    }
    
    func unenabledLikeButton() {
        likeButton.isEnabled = false
    }
    
    func updateLikeImage() {
        var colorLikeButton = UIColor.ypwhiteUniversal
        if presenter?.isLiked() ?? false {
            colorLikeButton = UIColor.ypRedUniversal
        }
        likeButton.setImage(UIImage(systemName: "heart.fill")?.withTintColor(colorLikeButton, renderingMode: .alwaysOriginal), for: .normal)
    }
    
    private func addSubviews() {
        contentView.addSubview(iconImageView)
        iconImageView.addSubview(activityIndicator)
        contentView.addSubview(likeButton)

        contentView.addSubview(centralStack)
        centralStack.addArrangedSubview(nameLabel)
        centralStack.addArrangedSubview(ratingView)
        centralStack.addArrangedSubview(autorLabel)

        contentView.addSubview(priceStack)
        priceStack.addArrangedSubview(priceTitleLabel)
        priceStack.addArrangedSubview(priceLabel)

        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            iconImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 16),
            iconImageView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            iconImageView.widthAnchor.constraint(equalToConstant: 108),
            iconImageView.heightAnchor.constraint(equalToConstant: 108),

            activityIndicator.centerXAnchor.constraint(equalTo: iconImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            
            likeButton.trailingAnchor.constraint(equalTo: iconImageView.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: iconImageView.topAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 42),
            likeButton.widthAnchor.constraint(equalToConstant: 42),

            centralStack.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 20),
            centralStack.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
            centralStack.widthAnchor.constraint(equalToConstant: 80),

            ratingView.widthAnchor.constraint(equalToConstant: 68),
            ratingView.heightAnchor.constraint(equalToConstant: 12),

            priceStack.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -39),
            priceStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
    }
    
}
