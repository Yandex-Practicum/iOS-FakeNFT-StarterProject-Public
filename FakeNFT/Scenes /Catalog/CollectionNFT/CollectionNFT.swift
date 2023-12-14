//
//  CollectionNFT.swift
//  FakeNFT
//
//  Created by Dolnik Nikolay on 13.12.2023.
//

import UIKit

final class CollectionNFTViewController: UIViewController {
    
    // MARK: - Properties
    
    let servicesAssembly: ServicesAssembly
    
    private var presenter: CatalogPresenterProtocol?
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.frame = view.bounds
        scroll.backgroundColor = .yellow
        scroll.alwaysBounceHorizontal = false
        scroll.contentSize = CGSize(width: view.frame.width, height: 1500)
        return scroll
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypWhite
//        view.frame = self.view.bounds
//        view.frame.size =  CGSize(width: self.view.frame.width, height: 1000)
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Cover Collection")
        view.clipsToBounds = true
        return view
    }()
    
    let stackViewTextLabel: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 0
        sv.alignment = .leading
        sv.distribution = .fill
        return sv
    }()
    
    let stackViewNameLabel: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 8
        sv.alignment = .leading
        sv.distribution = .fillEqually
        return sv
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Peach"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private var authorLable: UILabel = {
        let label = UILabel()
        label.text = "Автор коллекции ...."
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private var descriptionLable: UILabel = {
        let label = UILabel()
        label.text = "Персиковый - как облака над закатным солнецм в окенае. В этой коллекции совмещены трогательная нежность и живая игривость сказачных зефирных зверей."
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(CollectionNFTCell.self)
        collection.showsVerticalScrollIndicator = false
        collection.layer.masksToBounds = true
        return collection
    }()
    
    
    
    // MARK: - Init
    
    convenience init(servicesAssembly: ServicesAssembly){
        self.init(servicesAssembly: servicesAssembly, presenter: CatalogPresenter())
    }
    
    init(servicesAssembly: ServicesAssembly, presenter: CatalogPresenterProtocol) {
        self.servicesAssembly = servicesAssembly
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    
    // MARK: - Functions
    
    func configUI() {
        view.backgroundColor = .systemBackground
      
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        //Обложка Коллекции
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        //Формируем описание Коллекции
        contentView.addSubview(stackViewTextLabel)
        stackViewTextLabel.translatesAutoresizingMaskIntoConstraints = false
        [stackViewNameLabel, descriptionLable ].forEach{
            stackViewTextLabel.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        //Формируем описание названия Коллекции и автора
        [nameLabel, authorLable ].forEach{
            stackViewNameLabel.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        //Настраиваем коллекцию
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            contentView.heightAnchor.constraint(equalToConstant: 1500),
           // contentView.widthAnchor.constraint(equalToConstant: view.frame.width),
            contentView.widthAnchor.constraint(equalToConstant: scrollView.frame.width),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 310),
            
            stackViewTextLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            stackViewTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackViewTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackViewTextLabel.heightAnchor.constraint(equalToConstant: 136),
            
            collectionView.topAnchor.constraint(equalTo: stackViewTextLabel.bottomAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    
}


// MARK: - CollectionView Delegate && DataSource

extension CollectionNFTViewController: UICollectionViewDelegate, UICollectionViewDataSource {
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CollectionNFTCell = collectionView.dequeueReusableCell(indexPath: indexPath)

        return cell
    }
    
}


//MARK: - UITCollectionView FlowLayout

extension CollectionNFTViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 108, height: 192)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}
