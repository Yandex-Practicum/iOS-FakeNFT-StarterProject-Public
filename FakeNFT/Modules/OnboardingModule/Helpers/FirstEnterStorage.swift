//
//  FirstEnterStorage.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 12.07.2023.
//

import Foundation

protocol OnboardingCheckerProtocol {
    var hasEnteredBefore: Bool { get set }
    func completeOnboarding()
}

final class OnboardingFirstEnterStorage: OnboardingCheckerProtocol {
    let userDefaults = UserDefaults.standard
    
    var hasEnteredBefore: Bool {
        get {
            userDefaults.bool(forKey: "FirstLaunch")
        }
        set {
            userDefaults.set(newValue, forKey: "FirstLaunch")
        }
    }
    
    func completeOnboarding() {
        hasEnteredBefore = true
    }
}
