import UIKit

final class RatingStarsStackView: UIStackView {
    
    private struct RatingConstants {
        
        let starsCount: Int = 5
        let starHeight: CGFloat
        let starWeight: CGFloat
        
        init(starHeight: CGFloat, starWeight: CGFloat) {
            self.starHeight = starHeight
            self.starWeight = starWeight
        }
    }
    
    private let ratingStars = RatingConstants(starHeight: 11.25, starWeight: 12)
    private let feedbackGenerator = UISelectionFeedbackGenerator()
    var rating: Int = 0
    
    private lazy var stars: [UIImageView] = {
        (0..<ratingStars.starsCount).map { _ in
            let image = UIImage(systemName: "star")
            let highlightedImage = UIImage(systemName: "star.fill")
            let imageView = UIImageView(image: image, highlightedImage: highlightedImage)
            imageView.contentMode = .scaleAspectFill
            return imageView
        }
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        stars.forEach { addArrangedSubview($0) }
        spacing = 2
        axis = .horizontal
        distribution = .equalSpacing
    }
    
    func setStars() {
        for i in 0..<ratingStars.starsCount {
            stars[i].isHighlighted = i < rating ? true : false
            stars[i].tintColor = i < rating ? UIColor(resource: .ypYellowUn) : UIColor(resource: .ypLightGray)
        }
    }
}
