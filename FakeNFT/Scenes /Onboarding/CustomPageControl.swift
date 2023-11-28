import UIKit

final class CustomPageControl: UIView {
    var selectSegment: Int = 0 {
        didSet {
            setupDynamicSegments()
        }
    }

    var countSegment: Int = 0 {
        didSet {
            createSegmentStackView()
        }
    }

    private let segmentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    init() {
        super.init(frame: .zero)
        addSubview(segmentStackView)
        createSegmentStackView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupStaticSegments() {
        segmentStackView.arrangedSubviews.forEach { segmentStackView.removeArrangedSubview($0) }
        for _ in (0..<countSegment) {
            let segment = UIProgressView()
            segment.translatesAutoresizingMaskIntoConstraints = false
            segment.trackTintColor = .white
            segmentStackView.addArrangedSubview(segment)
        }
    }

    private func setupDynamicSegments() {
        for (index, subview) in segmentStackView.arrangedSubviews.enumerated() {
            if let subview = subview as? UIProgressView {
                subview.progress = index == selectSegment ? 1.0 : 0.0
                subview.progressTintColor = index == selectSegment ? .lightGray : .white
            }
        }
    }

    private func createSegmentStackView() {
        setupStaticSegments()
        selectSegment = 0
        NSLayoutConstraint.activate([
            segmentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            segmentStackView.topAnchor.constraint(equalTo: topAnchor),
            segmentStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
