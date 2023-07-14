//
//  OnboardingViewModel.swift
//  FakeNFT
//
//  Created by Aleksandr Eliseev on 12.07.2023.
//

import Foundation
import Combine

final class OnboardingViewModel {
    @Published private (set) var finishOnboarding: Bool = false
    
    func exitOnboarding() {
        self.finishOnboarding = true
    }
}
