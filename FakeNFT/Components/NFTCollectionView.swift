import UIKit

final class NFTCollectionView: UICollectionView {
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 9
        layout.sectionInset = UIEdgeInsets(top: 24, left: 16, bottom: 0, right: 16)
        layout.itemSize = CGSize(width: 108, height: 172)
        super.init(frame: .zero, collectionViewLayout: layout)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.backgroundColor = .whiteDay
        
        register(NFTCollectionCell.self, forCellWithReuseIdentifier: "NFTCollectionViewCell")
    }
}
