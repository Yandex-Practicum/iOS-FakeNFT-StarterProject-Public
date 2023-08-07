import UIKit

final class CustomTextView: UITextView {
    // MARK: - Private properties
    private let placeholderLabel = UILabel()
    private let insets = UIEdgeInsets(top: 11, left: 11, bottom: 11, right: 32)
    
    // MARK: - Lifecycle
    init(withPlaceholder text: String) {
        super.init(frame: .zero, textContainer: nil)
        uiConfiguration(with: text)
        configurePlaceholder(with: text)
        addTextChangeObserver()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func uiConfiguration(with text: String) {
        textContainerInset = insets
        font = .bodyRegular
        textColor = .ypBlack
        backgroundColor = .ypLightGray
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }
    
    private func configurePlaceholder(with text: String) {
        placeholderLabel.textColor = .ypGrayUniversal
        placeholderLabel.font = .bodyRegular
        placeholderLabel.text = text
        placeholderLabel.layer.zPosition = -2
        
        addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            placeholderLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            placeholderLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    
    private func addTextChangeObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(customTextViewTextDidChange),
            name: UITextView.textDidChangeNotification,
            object: self
        )
    }
    
    @objc private func customTextViewTextDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
}
