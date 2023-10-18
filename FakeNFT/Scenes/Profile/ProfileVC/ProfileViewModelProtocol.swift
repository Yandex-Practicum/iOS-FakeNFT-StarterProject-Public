import Foundation

protocol ProfileViewModelProtocol: AnyObject {

    var profileObservable: Observable<Profile?> { get }
    var showErrorAlert: ((String) -> Void)? { get set }
    func changeProfile(profile: Profile)
    func fetchProfile()
}
