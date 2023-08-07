import UIKit

final class EditedParameterLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    init(text: String) {
        super.init(frame: .zero)
        self.text = text
        commonInit()
    }
    
    private func commonInit() {
        textColor = .ypBlack
        font = .headline2
    }
}
