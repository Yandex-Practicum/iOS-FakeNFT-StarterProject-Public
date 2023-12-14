import UIKit

protocol NftCatalogView: AnyObject {
    
}

final class CatalogViewController: UIViewController {

    
    // MARK: - Properties
    
    let servicesAssembly: ServicesAssembly
    let testNftButton = UIButton()
    private var presenter: CatalogPresenterProtocol?
    private let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.showsVerticalScrollIndicator = false
        table.layer.masksToBounds = true
        return table
    }()
    
    // MARK: - Initialization
    
    convenience init(servicesAssembly: ServicesAssembly){
        self.init(servicesAssembly: servicesAssembly, presenter: CatalogPresenter())
    }
    
    init(servicesAssembly: ServicesAssembly, presenter: CatalogPresenterProtocol) {
        self.servicesAssembly = servicesAssembly
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        navBar()
        configUI()
    }
    
    
    // MARK: - Functions
    
    func navBar(){
        if let navigationBar = navigationController?.navigationBar {
            let item = UIBarButtonItem(image: UIImage(named: "Light"), style: .plain, target: self, action: #selector(addSorting))
            navigationBar.topItem?.setRightBarButton(item, animated: false)
        }
        navigationItem.backButtonTitle = ""
      
    }
    
    func configUI(){
        
        view.addSubview(testNftButton)
        testNftButton.constraintCenters(to: view)
        testNftButton.setTitle(Constants.openNftTitle, for: .normal)
        testNftButton.addTarget(self, action: #selector(showNft), for: .touchUpInside)
        testNftButton.setTitleColor(.systemBlue, for: .normal)
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CatalogNFTCell.self)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
   func showNFTCollection() {
       let vc = CollectionNFTViewController(servicesAssembly: servicesAssembly)
       navigationController?.pushViewController(vc, animated: true)
    }

    @objc
    func showNft() {
        let assembly = NftDetailAssembly(servicesAssembler: servicesAssembly)
        let nftInput = NftDetailInput(id: Constants.testNftId)
        let nftViewController = assembly.build(with: nftInput)
        present(nftViewController, animated: true)
    }
    
    @objc
    func addSorting(){
        
    }
}

// MARK: - UITableViewDataSource && Delegate

extension CatalogViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CatalogNFTCell = tableView.dequeueReusableCell()
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Переход на экран коллекции NFT
        showNFTCollection()
    }
    
}


extension CatalogViewController: NftCatalogView {
    
}
 
private enum Constants {
    static let openNftTitle = NSLocalizedString("Catalog.openNft", comment: "")
    static let testNftId = "22"
}

