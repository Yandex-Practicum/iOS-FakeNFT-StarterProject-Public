import Foundation

extension CartPaymentViewModel {
    public enum ViewState: Equatable {
        public static func == (lhs: CartPaymentViewModel.ViewState, rhs: CartPaymentViewModel.ViewState) -> Bool {
            guard case .loaded(let lhsModel) = lhs,
                  case .loaded(let rhsModel) = rhs
            else {
                return false
            }

            guard let lhsModel = lhsModel, let rhsModel = rhsModel else { return false }
            return lhsModel == rhsModel
        }

        case loading
        case loaded(CurrenciesViewModel?)
        case empty
    }
}
