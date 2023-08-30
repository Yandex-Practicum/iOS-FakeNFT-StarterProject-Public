import UIKit

protocol OnboardingViewModelProtocol: AnyObject {
    func getImage(index: Int) -> UIImage
    func getTitle(index: Int) -> String
    func getDescription(index: Int) -> String
}
