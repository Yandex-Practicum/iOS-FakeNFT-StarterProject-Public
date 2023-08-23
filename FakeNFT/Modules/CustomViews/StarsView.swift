import UIKit

final class StarsView: UIView {
    enum Rating: Int {
        case zero = 0
        case one
        case two
        case three
        case four
        case five
    }

    private enum Constants {
        static let stackViewSpacing: CGFloat = 2
    }

    var rating: Rating = .zero {
        didSet {
            self.setRating(self.rating)
        }
    }

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = Constants.stackViewSpacing
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        return stackView
    }()

    private let stars: [UIImageView] = {
        var stars: [UIImageView] = []

        for _ in 0..<5 {
            let starImage = UIImage.Icons.star
            let starImageView = UIImageView(image: starImage)
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            starImageView.tintColor = .appLightGray
            starImageView.contentMode = .scaleAspectFit

            stars.append(starImageView)
        }

        return stars
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension StarsView {
    func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false

        self.addSubviews()
        self.addConstraints()
    }

    func addSubviews() {
        self.addSubview(self.stackView)
        self.stars.forEach { self.stackView.addArrangedSubview($0) }
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.topAnchor),
            self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

private extension StarsView {
    func setRating(_ rating: Rating) {
        let rating = rating.rawValue
      
        self.stars.forEach { star in
            guard let indexOfStar = self.stars.firstIndex(of: star) else { return }
            star.tintColor = indexOfStar < rating ? .yellowUniversal : .appLightGray
        }
    }
}
