
import UIKit

final class ProfileDetailInfoCell: UITableViewCell {
    
    static let cellID = "cellID"
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SFProText-Bold", size: 17)
        label.textColor = UIColor.ypBlack
        return label
    }()
    
    private lazy var imageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
        imageView.image = UIImage(systemName: "chevron.right", withConfiguration: boldConfig)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.ypBlack
        return imageView
    }()
    
    func configureCell(name: String) {
        nameLabel.text = name
        selectionStyle = .none
        addSubviews()
    }
    
    private func addSubviews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(imageImageView)
        
        NSLayoutConstraint.activate([
            imageImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imageImageView.widthAnchor.constraint(equalToConstant: 7.98),
            imageImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: imageImageView.leadingAnchor, constant: 8),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
