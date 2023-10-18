import UIKit

final class ProfileViewModel: ProfileViewModelProtocol {

    private var dataProvider: DataProviderProtocol?

    var profileObservable: Observable<Profile?> {
        $profile
    }

    @Observable
    private(set) var profile: Profile?
    var showErrorAlert: ((String) -> Void)?

    init(dataProvider: DataProviderProtocol?) {
        self.dataProvider = dataProvider
        fetchProfile()
    }

    func fetchProfile() {
        dataProvider?.fetchProfile(completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                self.profile = profile
            case .failure(let failure):
                let errorString = HandlingErrorService().handlingHTTPStatusCodeError(error: failure)
                self.showErrorAlert?(errorString ?? "")
            }
        })
    }

    func changeProfile(profile: Profile) {
        dataProvider?.changeProfile(profile: profile, completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                self.profile = profile
            case .failure(let failure):
                let errorString = HandlingErrorService().handlingHTTPStatusCodeError(error: failure)
                self.showErrorAlert?(errorString ?? "")
            }
        })
    }
}

