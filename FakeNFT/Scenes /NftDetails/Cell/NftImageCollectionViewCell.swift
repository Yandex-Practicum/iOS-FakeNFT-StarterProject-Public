import UIKit

final class NftImageCollectionViewCell: UICollectionViewCell, ReuseIdentifying {

    // MARK: - Properties

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        return scrollView
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(scrollView)
        scrollView.constraintEdges(to: contentView)

        scrollView.addSubview(imageView)
        imageView.constraintCenters(to: scrollView)
        imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    func configure(with cellModel: NftDetailCellModel) {
        imageView.kf.setImage(with: cellModel.url)
    }
}

// MARK: - UIScrollViewDelegate

extension NftImageCollectionViewCell: UIScrollViewDelegate {

    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
