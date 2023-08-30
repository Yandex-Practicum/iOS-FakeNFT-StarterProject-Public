import UIKit

final class OnboardingViewModel: OnboardingViewModelProtocol {
    private let images = [Resources.Images.Onboarding.firstImage,
                          Resources.Images.Onboarding.secondImage,
                          Resources.Images.Onboarding.thirdImage]
    
    private let titles = [L10n.Onboarding.research,
                          L10n.Onboarding.collect,
                          L10n.Onboarding.competit]
    
    private let descriptions = [L10n.Onboarding.Research.text,
                                L10n.Onboarding.Collect.text,
                                L10n.Onboarding.Competit.text]
    
    func getImage(index: Int) -> UIImage {
        images[index] ?? UIImage()
    }
    
    func getTitle(index: Int) -> String {
        titles[index]
    }
    
    func getDescription(index: Int) -> String {
        descriptions[index]
    }
}
