import UIKit

final class RatingView: UIStackView {
	
	// MARK: Lifecycle
	
	init() {
		super.init(frame: .zero)
		translatesAutoresizingMaskIntoConstraints = false
		
		axis = .horizontal
		spacing = 2
		
		(1...5).forEach { i in
			let imageView = getStarImageView(UIImage(named: "Star_active"))
			imageView.translatesAutoresizingMaskIntoConstraints = false
			
			imageView.tag = i
			addArrangedSubview(imageView)
		}
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: Public methods
	
	func setRating(rating: Int) {
		subviews.forEach {
			if let imageView = $0 as? UIImageView {
				imageView.image = imageView.tag > rating ?
				UIImage(named: "Star_no_active") :
				UIImage(named: "Star_active")
			}
		}
	}
	
	// MARK: Private methods
	
	private func getStarImageView(_ image: UIImage?) -> UIImageView {
		let imageView = UIImageView(image: image)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.frame = CGRect(x: 0, y: 0, width: 12, height: 12)
		
		NSLayoutConstraint.activate([
			imageView.widthAnchor.constraint(equalToConstant: imageView.frame.width),
			imageView.heightAnchor.constraint(equalToConstant: imageView.frame.height)
		])
		
		return imageView
	}
}
