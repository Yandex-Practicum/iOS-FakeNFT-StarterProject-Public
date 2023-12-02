import UIKit

final class OnboardingViewController: UIViewController {
    private let pageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(resource: .white)
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .left
        return label
    }()

    private let textInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(resource: .white)
        label.font = .caption1
        label.textAlignment = .left
        label.numberOfLines = 4
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private lazy var textStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(textInfoLabel)
        return stackView
    }()

    init(pageImageView: UIImage, title: String, text: String) {
        self.pageImageView.image = pageImageView
        self.titleLabel.text = title
        self.textInfoLabel.text = text
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        addGradient()
        setLetterSpacing(for: titleLabel)
    }

    private func createView() {
        [pageImageView, textStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        activateConstrants()
    }

    private func activateConstrants() {
        NSLayoutConstraint.activate([
            pageImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageImageView.topAnchor.constraint(equalTo: view.topAnchor),
            pageImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            textStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 230)
        ])
    }

    private func addGradient() {
        pageImageView.layoutIfNeeded()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = pageImageView.bounds
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor(resource: .black).withAlphaComponent(0.8).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        pageImageView.layer.addSublayer(gradientLayer)
    }

    private func setLetterSpacing(for label: UILabel) {
        let attributedString = NSMutableAttributedString(string: label.text ?? "")
        attributedString.addAttribute(.kern, value: 1.5, range: NSRange(location: 0, length: attributedString.length))
        label.attributedText = attributedString
    }
}
