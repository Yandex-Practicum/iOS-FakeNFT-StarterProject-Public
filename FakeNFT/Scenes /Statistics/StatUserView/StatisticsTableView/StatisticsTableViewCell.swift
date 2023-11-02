import UIKit
import Kingfisher

final class StatisticsTableViewCell: UITableViewCell, ReuseIdentifying {
    private var number: UILabel = {
        var number = UILabel()
        number.font = .caption1
        number.textColor = .textPrimary
        return number
    }()

    private let profileView = ProfileCellView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        contentView.backgroundColor = .background
        contentView.addSubview(number)
        number.translatesAutoresizingMaskIntoConstraints = false

        profileView.translatesAutoresizingMaskIntoConstraints = false

        let hStack = UIStackView(arrangedSubviews: [number, profileView])
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.axis = .horizontal
        hStack.spacing = 12
        contentView.addSubview(hStack)

        let constraints = [
            hStack.topAnchor.constraint(equalTo: topAnchor),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 88),
            profileView.heightAnchor.constraint(equalToConstant: 80)
        ]

        constraints.forEach {
            $0.priority = .defaultHigh
        }

        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        profileView.imageURL = nil
    }

    func configureWith(model: StatisticsTableViewCellModel) {
        number.text = model.number.description
        profileView.imageURL = model.profilePhoto
        profileView.text = model.profileName
        profileView.counter = model.profileNFTCount
    }
}
