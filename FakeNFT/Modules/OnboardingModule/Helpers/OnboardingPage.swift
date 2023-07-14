//
//  OnboardingPage.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 13.07.2023.
//

import UIKit

enum OnboardingPage: CaseIterable {
    case discover, collect, compete
    
    var backgroundImage: UIImage? {
        switch self {
        case .discover:
            return UIImage(named: K.Onboarding.Background.onboarding1)
        case .collect:
            return UIImage(named: K.Onboarding.Background.onboarding2)
        case .compete:
            return UIImage(named: K.Onboarding.Background.onboarding3)
        }
    }
    
    var titleLabelText: String {
        switch self {
        case .discover:
            return K.Onboarding.Titles.discoverOnboardingPageTitle
        case .collect:
            return K.Onboarding.Titles.collectOnboardingPageTitle
        case .compete:
            return K.Onboarding.Titles.competeOnboardingPageTitle
        }
    }
    
    var pageDescription: String {
        switch self {
        case .discover:
            return K.Onboarding.Descriptions.discoverOnboardingPageDescription
        case .collect:
            return K.Onboarding.Descriptions.collectOnboardingPageDescription
        case .compete:
            return K.Onboarding.Descriptions.competeOnboardingPageDescription
        }
    }
    
    var closeButtonIsHidden: Bool {
        switch self {
        case .discover:
            return false
        case .collect:
            return false
        case .compete:
            return true
        }
    }
    
    var proceedButtonIsHidden: Bool {
        switch self {
        case .discover:
            return true
        case .collect:
            return true
        case .compete:
            return false
        }
    }
}
