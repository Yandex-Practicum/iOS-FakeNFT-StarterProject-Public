import UIKit

final class OnboardingPageViewController: UIPageViewController {
    private lazy var pages: [UIViewController] = {
        let firstPage = OnboardingViewController(
            pageImageView: UIImage(resource: .onboarding1),
            title: L10n.Onboarding.titleFirst,
            text: L10n.Onboarding.infoFirst
        )
        let secondPage = OnboardingViewController(
            pageImageView: UIImage(resource: .onboarding2),
            title: L10n.Onboarding.titleSecond,
            text: L10n.Onboarding.infoSecond
        )
        let thirdPage = OnboardingViewController(
            pageImageView: UIImage(resource: .onboarding3),
            title: L10n.Onboarding.titleThird,
            text: L10n.Onboarding.infoThird
        )
        return [firstPage, secondPage, thirdPage]
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .closeWhite), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(tapOnButton), for: .touchUpInside)
        return button
    }()

    private lazy var onButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.backgroundColor = .black
        button.titleLabel?.font = .bodyBold
        button.setTitle(L10n.Onboarding.buttonText, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(tapOnButton), for: .touchUpInside)
        return button
    }()

    private lazy var pageControl: CustomPageControl = {
        let customPageControl = CustomPageControl()
        return customPageControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
            if let currentIndex = self.pages.firstIndex(of: first) {
                self.updateButtonVisibility(for: currentIndex)
                        }
        }
        pageControl.countSegment = pages.count
        createView()
    }

    private func createView() {
        [pageControl, onButton, closeButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0) }
        activateConstrants()
    }

    private func activateConstrants() {
        NSLayoutConstraint.activate([
            onButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            onButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            onButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            onButton.heightAnchor.constraint(equalToConstant: 60),
            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            pageControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            pageControl.heightAnchor.constraint(equalToConstant: 4),
            closeButton.trailingAnchor.constraint(equalTo: pageControl.trailingAnchor),
            closeButton.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 16),
            closeButton.heightAnchor.constraint(equalToConstant: 42),
            closeButton.widthAnchor.constraint(equalToConstant: 42)
        ])
    }

    private func updateButtonVisibility(for index: Int) {
        onButton.isHidden = index < pages.count - 1
        closeButton.isHidden = index == pages.count - 1
    }

    @objc
    private func tapOnButton() {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Invalid config")
        }
        UserDefaults.standard.set(true, forKey: "shownOnboardingEarlier")
        window.rootViewController = TabBarController()
    }
}

extension OnboardingPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            willTransitionTo pendingViewControllers: [UIViewController]) {
        if let nextViewController = pendingViewControllers.first,
           let nextIndex = pages.firstIndex(of: nextViewController) {
            updateButtonVisibility(for: nextIndex)
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            updateButtonVisibility(for: currentIndex)
            pageControl.selectSegment = currentIndex

        }
    }
}

extension OnboardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController), viewControllerIndex > 0 else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        return pages[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController),
                viewControllerIndex < pages.count - 1 else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        return pages[nextIndex]
    }
}
