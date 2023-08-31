import UIKit
enum Rating: Int {
    case zero = 0
    case one
    case two
    case three
    case four
    case five
}

final class StarView: UIView {

    var rating: Rating = .zero {
        didSet {
            setRating(rating)
        }
    }

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let stars: [UIImageView] = {
        var stars = [UIImageView]()

        for _ in 0..<5 {
            let starImage = UIImage(named: "Star")
            let starIV = UIImageView(image: starImage)
            starIV.translatesAutoresizingMaskIntoConstraints = false
            starIV.tintColor = .lightGray
            starIV.contentMode = .scaleAspectFit
            stars.append(starIV)
        }
        return stars
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension StarView {
    func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        addStars()
        addConstraint()
    }

    func addStars() {
        self.addSubview(self.stackView)
        self.stars.forEach { stackView.addArrangedSubview($0) }
    }

    func addConstraint() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func setRating(_ rating: Rating) {
        let rating = rating.rawValue

        stars.forEach { star in
            guard let starIndex = stars.firstIndex(of: star) else { return }
            star.tintColor = starIndex < rating ? UIColor.yellow : UIColor.lightGray
        }
    }
}
