import Foundation

protocol ProfileEditPresenterProtocol: AnyObject {
    func change(parameter: EditableParameter, with text: String)
    func isProfileChanged() -> Bool
    func getNewProfile() -> ProfileResponseModel
}
