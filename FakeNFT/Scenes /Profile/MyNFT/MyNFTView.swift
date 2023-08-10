import UIKit
import Kingfisher

final class MyNFTView: UIView {
    private let viewModel: MyNFTViewModelProtocol
    private(set) var myNFTs: [NFTNetworkModel]?
    
    private lazy var myNFTTable: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MyNFTCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = false
        tableView.isUserInteractionEnabled = true
        return tableView
    }()
    
    init(frame: CGRect, viewModel: MyNFTViewModelProtocol) {
        self.viewModel = viewModel
        self.myNFTs = viewModel.myNFTs
        super.init(frame: .zero)
        
        self.backgroundColor = .white
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateNFT(nfts: [NFTNetworkModel]) {
        self.myNFTs = nfts
        myNFTTable.reloadData()
    }
    
    private func setupConstraints() {
            addSubview(myNFTTable)
        
        NSLayoutConstraint.activate([
            myNFTTable.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            myNFTTable.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            myNFTTable.leadingAnchor.constraint(equalTo: leadingAnchor),
            myNFTTable.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

extension MyNFTView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let myNFTs = myNFTs else { return 0 }
        return myNFTs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyNFTCell = tableView.dequeueReusableCell()
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        guard let myNFTs = myNFTs,
              !myNFTs.isEmpty else { return MyNFTCell() }
              
        let myNFT = myNFTs[indexPath.row]
        
        let model = MyNFTCell.CellModel(
            image: myNFT.images.first ?? "",
            name: myNFT.name,
            rating: myNFT.rating,
            author: viewModel.authors[myNFT.author] ?? "",
            price: myNFT.price,
            isFavorite: viewModel.likedIDs?.contains(myNFT.id) ?? false,
            id: myNFT.id
        )
        
        cell.tapAction = { [weak self] in
            let tappedNFT = self?.myNFTs?.filter({ $0.id == myNFT.id }).first
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "myNFTliked"), object: tappedNFT)
            if let tappedNFTid = tappedNFT?.id { self?.viewModel.toggleLikeFromMyNFT(id: tappedNFTid) }
        }
        cell.configureCell(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
