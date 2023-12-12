import UIKit

final class CatalogViewController: UIViewController {

    let servicesAssembly: ServicesAssembly
    let testNftButton = UIButton()
    private var presenter: CatalogPresenterProtocol?
    private let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.layer.masksToBounds = true
        return table
    }()

    // MARK: - Init
    
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
        configUI()
    }
    
    
    // MARK: - Functions
    
    func configUI(){
        
        view.addSubview(testNftButton)
        testNftButton.constraintCenters(to: view)
        testNftButton.setTitle(Constants.openNftTitle, for: .normal)
        testNftButton.addTarget(self, action: #selector(showNft), for: .touchUpInside)
        testNftButton.setTitleColor(.systemBlue, for: .normal)
        
        view.addSubview(tableView)
        tableView.backgroundColor = .red
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        //tableView.register(<#T##cellClass: AnyClass?##AnyClass?#>, forCellReuseIdentifier: <#T##String#>)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }

    @objc
    func showNft() {
        let assembly = NftDetailAssembly(servicesAssembler: servicesAssembly)
        let nftInput = NftDetailInput(id: Constants.testNftId)
        let nftViewController = assembly.build(with: nftInput)
        present(nftViewController, animated: true)
    }
}

// MARK: - UITableViewDataSource && Delegate

extension CatalogViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 179
    }
    
}




private enum Constants {
    static let openNftTitle = NSLocalizedString("Catalog.openNft", comment: "")
    static let testNftId = "22"
}
