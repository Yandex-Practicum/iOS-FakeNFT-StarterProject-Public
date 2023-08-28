import Foundation

// MARK: - ProfileEditPresenterProtocol

protocol ProfileEditPresenterProtocol: AnyObject {
    var profileChanged: Bool { get }
    var newProfile: ProfileResponseModel { get }
    func change(parameter: EditableParameter, with text: String)
    func calculateViewYOffset(textFieldY: CGFloat, viewHeight: CGFloat, keyboardHeight: CGFloat) -> CGFloat
}
