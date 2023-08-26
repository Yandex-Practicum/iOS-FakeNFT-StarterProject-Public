import UIKit

final class StarRatingController: UIStackView {
    private var starsRating = 0
    private var starsEmptyPicName = "Star Empty"
    private var starsFilledPicName = "Star Filled"
    
    init(starsRating: Int = 0) {
        super.init(frame: .zero)
        
        self.starsRating = starsRating
        
        var starTag = 1
        for _ in 0..<starsRating {
            let image = UIImageView()
            image.image = UIImage.Icons.emptyStar
            image.tag = starTag
            self.addArrangedSubview(image)
            starTag += 1
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setStarsRating(rating: Int){
        self.starsRating = rating
        for subView in self.subviews {
            if let image = subView as? UIImageView{
                
                image.image = image.tag > starsRating ? UIImage.Icons.emptyStar : UIImage.Icons.fillStar
            }
        }
    }
}
