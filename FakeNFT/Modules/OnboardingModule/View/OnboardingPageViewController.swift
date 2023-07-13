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
    
    private var pages: [UIViewController] = [

    ]
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setPageViewControllers()
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
    func setupViewControllers() {
        guard let viewModel else { return }
        OnboardingPage.allCases.forEach({ pages.append(OnboardingViewController(viewModel: viewModel, page: $0)) })
    }
    
    func setPageViewControllers() {
        if let firstPage = pages.first {
            setViewControllers([firstPage], direction: .forward, animated: true)
        }
    }
}

// MARK: - Ext @objc
@objc private extension OnboardingPageViewController {
    func finishButtonTapped() {
        onFinish?()
    }
    
    func changeViewControllerOnTap(_ sender: UIPageControl) {
        let selectedPage = sender.currentPage < pages.count - 1 ? sender.currentPage + 1 : sender.currentPage - 1
        self.setViewControllers([pages[selectedPage]], direction: .forward, animated: true, completion: nil)
        
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
