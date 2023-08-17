import Foundation

// MARK: - ProfileEditPresenterProtocol

protocol ProfileEditPresenterProtocol: AnyObject {
    func change(parameter: EditableParameter, with text: String)
    func isProfileChanged() -> Bool
    func getNewProfile() -> ProfileResponseModel
}
