import Foundation

class ResultsPresenter {
    private weak var view: ResultsView?
    
    init(view: ResultsView) {
        self.view = view
    }
}
