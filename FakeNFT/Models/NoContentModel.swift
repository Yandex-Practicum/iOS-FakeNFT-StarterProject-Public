import Foundation

enum NoContent: String {
    case noInternet = "NOINTERNET"
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
