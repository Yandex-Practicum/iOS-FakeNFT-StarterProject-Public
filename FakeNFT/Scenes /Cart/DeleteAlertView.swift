import UIKit
import Kingfisher

final class DeleteAlertView: UIView {
    
    private var parent: UIViewController?
    private var onDelete: (() -> Void)?
    
    private let mainView = UIView()
    
    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        
        return imageView
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .segmentActive
        label.textAlignment = .center
        label.font = .caption2
        label.numberOfLines = 0
        label.text = ("Вы уверены, что хотите удалить объект из корзины?")
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.segmentActive
        button.setTitleColor(
            UIColor.background,
            for: .normal
        )
        button.setTitle("Вернуться", for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.bodyRegular
        
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 127, height: 44)
        button.backgroundColor = UIColor.segmentActive
        button.setTitleColor(.red, for: .normal)
        button.setTitle("Удалить", for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.bodyRegular
        
        return button
    }()
    
    private let buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        
        return stack
    }()
    
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    init(){
        super.init(frame: .zero)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(on viewController: UIViewController, with height: CGFloat, image: URL, onDelete: @escaping () -> Void) {
        parent = viewController
        self.onDelete = onDelete
        isHidden = false
        blurEffectView.layer.opacity = 0
        mainView.layer.opacity = 0
        mainView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        if !self.isDescendant(of: viewController.view) {
            add(on: viewController)
        }
        animateViewAppearance(on: viewController)
        nftImageView.kf.setImage(with: image)
        
        layoutIfNeeded()
        backButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteNft), for: .touchUpInside)
    }
    
    @objc
    private func dismissAlert() {
        guard let parent else {return}
        animateViewDismissing(on: parent)
        parent.view.layoutIfNeeded()
    }
    
    @objc
    private func deleteNft() {
        guard let parent else {return}
        onDelete?()
        animateViewDismissing(on: parent)
        parent.view.layoutIfNeeded()
    }
    
    private func add(on viewController: UIViewController) {
        guard let parentView = viewController.view else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(self)
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: parentView.topAnchor),
            self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor)
        ])
    }
    
    private func animateViewDismissing(on viewController: UIViewController) {
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options:[.curveEaseInOut],
            animations: {[weak self] in
                guard let self else {return}
                mainView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                mainView.layer.opacity = 0
            }, completion: {[weak self] isCompleted in
                if isCompleted {
                    UIView.animate(
                        withDuration: 0.1,
                        delay: 0,
                        options: [.curveEaseInOut],
                        animations: {[weak self] in
                            guard let self else {return}
                            self.blurEffectView.layer.opacity = 0
                            viewController.navigationController?.navigationBar.layer.opacity = 1
                            viewController.tabBarController?.tabBar.layer.opacity = 1
                        }, completion: {_ in
                            self?.isHidden = true
                        }
                    )
                }
            }
        )
    }
    
    private func animateViewAppearance(on viewController: UIViewController) {
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: [.curveLinear],
            animations: {[weak self] in
                guard let self else {return}
                blurEffectView.layer.opacity = 1
                viewController.navigationController?.navigationBar.layer.opacity = 0
                viewController.tabBarController?.tabBar.layer.opacity = 0
            },
            completion: {[weak self] isCompleted in
                guard let self else { return }
                if isCompleted {
                    UIView.animate(
                        withDuration: 0.2,
                        delay: 0,
                        options: [.curveEaseInOut],
                        animations: {[weak self] in
                            guard let self else {return}
                            mainView.transform = CGAffineTransform.identity
                            mainView.layer.opacity = 1
                        })
                }
            })
    }
    
    private func setupSubviews() {
        setupBlur()
        mainView.addSubviews(textLabel,
                             nftImageView,
                             buttonsStack)
        
        addSubviews(mainView)
        
        isUserInteractionEnabled = true
        [mainView,
         backButton,
         buttonsStack].forEach {
            $0.isUserInteractionEnabled = true
        }
        
        setupImageView()
        setupLabel()
        setupButtons()
        setupMainView()
    }
    
    private func setupMainView() {
        NSLayoutConstraint.activate([
            mainView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            mainView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            mainView.heightAnchor.constraint(equalToConstant: 220),
            mainView.widthAnchor.constraint(equalToConstant: 262)
        ])
    }
    
    private func setupBlur() {
        addSubviews(blurEffectView)
        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: self.topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
    }
    
    private func setupImageView() {
        NSLayoutConstraint.activate([
            nftImageView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.widthAnchor.constraint(equalToConstant: 108)
        ])
    }
    
    private func setupLabel() {
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 12),
            textLabel.centerXAnchor.constraint(equalTo: mainView.centerXAnchor)
        ])
    }
    
    private func setupButtons() {
        buttonsStack.addArrangedSubview(deleteButton)
        buttonsStack.addArrangedSubview(backButton)
        NSLayoutConstraint.activate([
            buttonsStack.topAnchor.constraint(equalTo: textLabel.bottomAnchor,constant: 20),
            buttonsStack.heightAnchor.constraint(equalToConstant: 44),
            buttonsStack.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            buttonsStack.widthAnchor.constraint(equalToConstant: 262)
        ])
        
    }
}
