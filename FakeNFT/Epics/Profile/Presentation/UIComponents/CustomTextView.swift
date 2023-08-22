import UIKit

final class CustomTextView: UITextView {
    // MARK: - Private properties
    
    private let placeholderLabel = UILabel()
    private var textChangeHandler: (String) -> Void
    private let insets = UIEdgeInsets(
        top: 11,
        left: 11,
        bottom: 11,
        right: 32
    )
    
    // MARK: - Lifecycle
    
    init(with placeholder: String, text: String, textChangeHandler: @escaping (String) -> Void) {
        self.textChangeHandler = textChangeHandler
        
        super.init(frame: .zero, textContainer: nil)
        
        self.autocorrectionType = .no
        self.spellCheckingType = .no
        isNeedToHidePlaceholderAndSet(text: text)
        uiConfiguration(with: placeholder)
        configurePlaceholder(with: placeholder)
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
    
    private func isNeedToHidePlaceholderAndSet(text: String) {
        if !text.isEmpty {
            self.text = text
            placeholderLabel.isHidden = true
        } else {
            placeholderLabel.isHidden = false
        }
    }
    
    // MARK: - Actions
    @objc private func customTextViewTextDidChange() {
        textChangeHandler(self.text)
        placeholderLabel.isHidden = !text.isEmpty
    }
}
