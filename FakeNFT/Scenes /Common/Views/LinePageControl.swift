import UIKit

final class LinePageControl: UIView {

    var numberOfItems: Int = 0 {
        didSet {
            setupStackView()
        }
    }

    var selectedItem: Int = 0 {
        didSet {
            selectedSegmentChanged()
        }
    }

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        return stackView
    }()

    init() {
        super.init(frame: .zero)

        addSubview(stackView)
        stackView.constraintEdges(to: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }

    func setupStackView() {
        stackView.arrangedSubviews.forEach { stackView.removeArrangedSubview($0) }

        for _ in (0..<numberOfItems) {
            let segment = UIView()
            segment.heightAnchor.constraint(equalToConstant: height).isActive = true
            segment.layer.cornerRadius = height / 2
            stackView.addArrangedSubview(segment)
        }

        selectedItem = 0
    }

    func selectedSegmentChanged() {
        for (index, subview) in stackView.arrangedSubviews.enumerated() {
            let isSelected = index == selectedItem
            subview.backgroundColor = isSelected ? .segmentBlack : .segmentLightGray
        }
    }
}

private let height: CGFloat = 4
