import UIKit

extension UIView {

  func constraintEdges(to view: UIView) {
    translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }

  func constraintCenters(to view: UIView) {
    translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      centerXAnchor.constraint(equalTo: view.centerXAnchor),
      centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }
}
