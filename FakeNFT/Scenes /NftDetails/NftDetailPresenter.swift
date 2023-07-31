import Foundation

protocol NftDetailPresenter {
  func loadImages()
}

final class NftDetailPresenterImpl: NftDetailPresenter {

  weak var view: NftDetailView?
  private let input: NftDetailInput
  private let service: NftService

  init(input: NftDetailInput, service: NftService) {
    self.input = input
    self.service = service
  }

  func loadImages() {
    service.loadNft(id: input.id) { [weak self] result in
      switch result {
      case .success(let nft):
        let cellModels = nft.images.map { NftDetailCellModel(url: $0) }
        self?.view?.displayCells(cellModels)
      case .failure(let error):
        print("ERROR \(error)")
        break // TODO: show error
      }
    }
  }
}
