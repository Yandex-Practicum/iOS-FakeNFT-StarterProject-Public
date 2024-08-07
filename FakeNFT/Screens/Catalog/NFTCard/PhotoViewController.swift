import UIKit
import Kingfisher
import CHIPageControl
import SnapKit

class PhotoViewController: UIViewController {
    private let swipeGestureRecognizer: UISwipeGestureRecognizer = {
        let swipeGestureRecognizer = UISwipeGestureRecognizer()
        swipeGestureRecognizer.direction = .left
        swipeGestureRecognizer.isEnabled = true
        return swipeGestureRecognizer
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        return scrollView
    }()

    private lazy var pageControl: CHIPageControlJaloro = {
        let pageControl = CHIPageControlJaloro()
        pageControl.numberOfPages = 3
        pageControl.radius = 4
        pageControl.currentPageTintColor = .black
        pageControl.tintColor = .lightGray
        pageControl.padding = 8
        pageControl.elementWidth = 109
        pageControl.elementHeight = 4
        return pageControl
    }()

    @objc func handleSwipe() {
        photoImageView.kf.setImage(with: image[(currentIndex + 1) % image.count], options: [.keepCurrentImageWhileLoading])
        currentIndex = (currentIndex + 1) % image.count
        UIView.transition(with: photoImageView, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: { [weak self] _ in
            self?.pageControl.set(progress: self!.currentIndex, animated: true)
        })
    }

    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "close"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()

    private func loadCoverImage(url: String) {
        guard let imageUrl = URL(string: url.urlDecoder ?? "") else {
            return
        }
        photoImageView.kf.setImage(with: imageUrl)
    }

    init(image: [URL], currentIndex: Int) {
        self.image = image
        self.currentIndex = currentIndex
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var image: [URL]
    var currentIndex: Int

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.contentSize = photoImageView.bounds.size
        swipeGestureRecognizer.addTarget(self, action: #selector(handleSwipe))
        photoImageView.addGestureRecognizer(swipeGestureRecognizer)
        loadCoverImage(url: "\(image.first!)")
        setupView()
    }

    private func setupView() {
        view.backgroundColor = .white

        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        scrollView.addSubview(photoImageView)
        photoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }

        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0

        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }

        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(38)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-24)
        }
    }

    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
}
extension PhotoViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = max(0, (scrollView.bounds.width - scrollView.contentSize.width) / 2)
        let offsetY = max(0, (scrollView.bounds.height - scrollView.contentSize.height) / 2)
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)

    }
}
