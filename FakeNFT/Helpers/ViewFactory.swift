import UIKit

final class ViewFactory {
    func createTextLabel() -> UILabel {
        let label = UILabel()
        label.font = .headline2
        return label
    }

    func createTextView() -> UITextView {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.font = .bodyRegular
        textView.backgroundColor = .nftLightgrey
        textView.layer.cornerRadius = 12
        textView.textContainerInset = UIEdgeInsets(top: 11, left: 10, bottom: 11, right: 10)
        return textView
    }
}
