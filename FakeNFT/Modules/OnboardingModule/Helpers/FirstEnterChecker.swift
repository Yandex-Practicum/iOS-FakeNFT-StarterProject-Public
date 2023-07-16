//
//  FirstEnterChecker.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 12.07.2023.
//

import Foundation

protocol FirstEnterCheckableProtocol {
    func shouldShowOnboarding() -> Bool
    func didCompleteOnboarding()
}

final class OnboardingFirstEnterChecker {
    private let onboardingFirstEnterStorage: OnboardingCheckerProtocol
    
    init(onboardingFirstEnterStorage: OnboardingCheckerProtocol) {
        self.onboardingFirstEnterStorage = onboardingFirstEnterStorage
    }
}

extension OnboardingFirstEnterChecker: FirstEnterCheckableProtocol {
    func shouldShowOnboarding() -> Bool {
        !onboardingFirstEnterStorage.hasEnteredBefore
    }
    
    func didCompleteOnboarding() {
        onboardingFirstEnterStorage.completeOnboarding()
        
    }
}
