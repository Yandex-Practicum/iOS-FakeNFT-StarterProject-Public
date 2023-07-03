import UIKit
import Kingfisher

final class MyNFTView: UIView {
    // MARK: - Properties
    private var viewController: MyNFTViewController?
    
    private(set) var myNFTs: [NFTNetworkModel]?
    
    //MARK: - Layout elements
    private lazy var myNFTTable: UITableView = {
        let myNFTTable = UITableView()
        myNFTTable.translatesAutoresizingMaskIntoConstraints = false
        myNFTTable.register(MyNFTCell.self)
        myNFTTable.dataSource = self
        myNFTTable.delegate = self
        myNFTTable.separatorStyle = .none
        myNFTTable.allowsMultipleSelection = false
        myNFTTable.isUserInteractionEnabled = true
        return myNFTTable
    }()
    
    // MARK: - Lifecycle
    init(frame: CGRect, viewController: MyNFTViewController) {
        super.init(frame: .zero)
        self.viewController = viewController
        
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
        UIBlockingProgressHUD.dismiss()
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

extension MyNFTView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let myNFTs = myNFTs else { return 0 }
        return myNFTs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyNFTCell = tableView.dequeueReusableCell()
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        guard let myNFT = myNFTs?[indexPath.row] else { return MyNFTCell() }
        cell.nftImage.kf.setImage(with: URL(string: myNFT.images[0]))
        cell.nftName.text = myNFT.name
        cell.nftRating.setStarsRating(rating: myNFT.rating)
        if let authorName = viewController?.getAuthorById(id: myNFT.author) {
            cell.nftAuthor.text = "от \(authorName)"}
        cell.nftPriceValue.text = "\(myNFT.price) ETH"
        cell.nftFavorite.nftID = myNFT.id
        cell.nftFavorite.isFavorite = false
        cell.nftFavorite.addTarget(self, action: #selector(didTapFavoriteButton(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    @objc
    func didTapFavoriteButton(sender: FavoriteButton) {
        sender.isFavorite.toggle()
        // TODO: Favorite functionality
    }
}

extension MyNFTView: UITableViewDelegate {
    
}
