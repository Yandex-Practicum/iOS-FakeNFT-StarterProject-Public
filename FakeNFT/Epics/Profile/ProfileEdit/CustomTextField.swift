import UIKit

class CustomTextField: UITextField {
    // MARK: - Private properties
    private let insets =  UIEdgeInsets(
        top: 11,
        left: 16,
        bottom: 11,
        right: 32
        )
    
    // MARK: - Lifecycle
    init(with text: String) {
        super.init(frame: .zero)
        uiConfiguration(with: text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Public methods
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    // MARK: - Private methods
    private func uiConfiguration(with text: String) {
        font = .bodyRegular
        textColor = .ypBlack
        backgroundColor = .ypLightGray
        layer.cornerRadius = 12
        layer.masksToBounds = true
        clearButtonMode = .whileEditing
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.ypGrayUniversal
        ]
        let attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: attributes
        )
        self.attributedPlaceholder = attributedPlaceholder
    }
}
