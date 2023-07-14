//
//  OnboardingPageViewController.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 12.07.2023.
//

import UIKit
import Combine

protocol OnboardingCoordinatable {
    var onFinish: (() -> Void)? { get set }
}

final class OnboardingPageViewController: UIPageViewController, OnboardingCoordinatable {
    var onFinish: (() -> Void)?
    
    var cancellables = Set<AnyCancellable>()
    var viewModel: OnboardingViewModel?
    
    private lazy var lineStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
                
        return stackView
    }()
    
    private var pages: [UIViewController] = []
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        dataSource = self
        bind()
        
    }
    
    private func bind() {
        guard let viewModel else { return }
        viewModel.$finishOnboarding
            .sink { [weak self] onboardingFinished in
                self?.finishFlow(onboardingFinished)
            }
            .store(in: &cancellables)
    }
    
    private func finishFlow(_ onboardingFinished: Bool) {
        onboardingFinished ? onFinish?() : ()
    }
}

// MARK: - Ext PageController
private extension OnboardingPageViewController {
    func setupUI() {
        setupViewControllers()
        setPageViewControllers()
        setupButtons()
        setupButton()
    }
    
    func setupViewControllers() {
        guard let viewModel else { return }
        OnboardingPage.allCases.forEach({ pages.append(OnboardingViewController(viewModel: viewModel, page: $0)) })
    }
    
    func setPageViewControllers() {
        if let firstPage = pages.first {
            setViewControllers([firstPage], direction: .forward, animated: true)
        }
    }
    
    func setupButtons() {
        pages.forEach { controller in
            guard let index = pages.firstIndex(of: controller) else { return }
            let button = CustomLineButton(number: index)
            button.addTarget(self, action: #selector(changeViewControllerOnTap), for: .touchUpInside)
            lineStackView.addArrangedSubview(button)
        }
    }
}

// MARK: - Ext @objc
@objc private extension OnboardingPageViewController {
    func changeViewControllerOnTap(_ sender: UIButton) {
        let selectedPage = sender.tag
        self.setViewControllers([pages[selectedPage]], direction: .forward, animated: true)
    }
}

// MARK: - Ext UIPageViewControllerDataSource
extension OnboardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return pages.last }
        return pages[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else { return pages.first }
        return pages[nextIndex]
    }
}

// MARK: - Ext Constraints
private extension OnboardingPageViewController {
    func setupButton() {
        view.addSubview(lineStackView)
        lineStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            lineStackView.heightAnchor.constraint(equalToConstant: 4),
            lineStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            lineStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            lineStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
