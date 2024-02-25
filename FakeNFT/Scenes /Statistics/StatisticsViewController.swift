import UIKit

final class StatisticsViewController: UIViewController {
	
	// MARK: Private Properties
	
	private let viewModel: StatisticsViewModelProtocol = StatisticsViewModel()
	
	private let reuseIdentifier = "cell"
	
	// MARK: Private UI Properties
	
	private lazy var sortButton = {
		let image = UIImage(named: "Sort")
		let button = UIButton()
		
		button.setImage(image, for: .normal)
		button.tintColor = .black
		button.addTarget(self, action: #selector(sortButtonDidTap), for: .touchUpInside)
		
		return UIBarButtonItem(customView: button)
	}()
	
	private lazy var tableView = {
		let tableView = UITableView()
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.separatorStyle = .none
		tableView.dataSource = self
		tableView.delegate = self
		
		return tableView
	}()
	
	// MARK: Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViews()
		setupConstraints()
		
		viewModel.$users.bind { _ in
			self.tableView.reloadData()
		}
		viewModel.getUsers()
	}
	
	// MARK: Private methods
	
	private func setupViews() {
		self.navigationItem.rightBarButtonItem = sortButton
		
		tableView.register(
			StatisticsTableViewCell.self,
			forCellReuseIdentifier: reuseIdentifier
		)
		
		
		view.addSubview(tableView)
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			tableView.widthAnchor.constraint(equalTo: view.widthAnchor)
		])
	}
	
	@objc private func sortButtonDidTap() {
		let sort = NSLocalizedString(
			"Sort",
			comment: ""
		)
		let sortByName = NSLocalizedString(
			"Sort.ByName",
			comment: ""
		)
		let sortByRating = NSLocalizedString(
			"Sort.ByRating",
			comment: ""
		)
		let cancelCaption = NSLocalizedString(
			"Sort.Cancel",
			comment: ""
		)
		
		let alert = UIAlertController(
			title: sort,
			message: nil,
			preferredStyle: .actionSheet
		)
		
		alert.addAction(UIAlertAction(
			title: sortByName,
			style: .default,
			handler: { _ in
				self.sortBy("name")
			}))
		alert.addAction(UIAlertAction(
			title: sortByRating,
			style: .default,
			handler: { _ in
				self.sortBy("rating")
			}))
		alert.addAction(UIAlertAction(
			title: cancelCaption,
			style: .cancel
		))
		
		present(alert, animated: true, completion: nil)
	}
	
	private func sortBy(_ sortBy: String) {
		viewModel.sortBy(sortBy)
	}
}

// MARK: UITableViewDataSource

extension StatisticsViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		viewModel.users.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard let cell = tableView.dequeueReusableCell(
			withIdentifier: reuseIdentifier,
			for: indexPath
		) as? StatisticsTableViewCell else {
			return StatisticsTableViewCell()
		}
		
		let cellViewModel = viewModel.users[indexPath.item]
		
		cell.viewModel = cellViewModel
		
		return cell
	}
}

// MARK: UITableViewDelegate

extension StatisticsViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		88
	}
}
