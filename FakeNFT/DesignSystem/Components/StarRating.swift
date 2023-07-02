import UIKit

class StarRatingController: UIStackView {
    
    //MARK: - Properties
    var starsRating = 0
    
    private var starsEmptyPicName = "Star Empty"
    private var starsFilledPicName = "Star Filled"
    
    // MARK: - Lifecycle
    init(starsRating: Int = 0) {
        super.init(frame: .zero)
        
        self.starsRating = starsRating
        
        var starTag = 1
        for _ in 0..<starsRating {
            let image = UIImageView()
            image.image = UIImage(named: starsEmptyPicName)
            image.tag = starTag
            self.addArrangedSubview(image)
            starTag = starTag + 1
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    func setStarsRating(rating: Int){
        self.starsRating = rating
        let stackSubViews = self.subviews
        for subView in stackSubViews {
            if let image = subView as? UIImageView{
                if image.tag > starsRating {
                    image.image = UIImage(named: starsEmptyPicName)
                }else{
                    image.image = UIImage(named: starsFilledPicName)
                }
            }
        }
    }
}
