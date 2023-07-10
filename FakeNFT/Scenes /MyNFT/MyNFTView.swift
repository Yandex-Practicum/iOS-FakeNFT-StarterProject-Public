import UIKit
import Kingfisher

final class MyNFTView: UIView {
    // MARK: - Properties
    private var viewModel: MyNFTViewModel
    
    private(set) var myNFTs: [NFTNetworkModel]?
    
    //MARK: - Layout elements
    private lazy var myNFTTable: UITableView = {
        let myNFTTable = UITableView()
        myNFTTable.translatesAutoresizingMaskIntoConstraints = false
        myNFTTable.register(MyNFTCell.self)
        myNFTTable.dataSource = self
        myNFTTable.delegate = self
        myNFTTable.backgroundColor = .white
        myNFTTable.separatorStyle = .none
        myNFTTable.allowsMultipleSelection = false
        myNFTTable.isUserInteractionEnabled = true
        return myNFTTable
    }()
    
    // MARK: - Lifecycle
    init(frame: CGRect, viewModel: MyNFTViewModel) {
        self.viewModel = viewModel
        self.myNFTs = viewModel.myNFTs
        super.init(frame: .zero)
        
        self.backgroundColor = .white
        addTable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func updateNFT(nfts: [NFTNetworkModel]) {
        self.myNFTs = nfts
        myNFTTable.reloadData()
    }
    
    //MARK: - Layout methods
    private func addTable() {
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
        guard let myNFT = myNFTs?[indexPath.row] else { return MyNFTCell() }
        
        let model = MyNFTCell.Model(
            image: myNFT.images[0],
            name: myNFT.name,
            rating: myNFT.rating,
            author: viewModel.authors[myNFT.author] ?? "",
            price: myNFT.price,
            isFavorite: viewModel.likedIDs?.contains(myNFT.id) ?? false,
            id: myNFT.id
        )
        
        cell.tapAction = {
            let tappedNFT = self.myNFTs?.filter({ $0.id == myNFT.id })[0]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "myNFTliked"), object: tappedNFT)
            if let tappedNFTid = tappedNFT?.id { self.viewModel.toggleLikeFromMyNFT(id: tappedNFTid) }
        }
        cell.configureCell(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
