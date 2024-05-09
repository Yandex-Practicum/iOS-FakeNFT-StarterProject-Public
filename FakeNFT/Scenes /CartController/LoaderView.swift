//
//  LoaderView.swift
//  FakeNFT
//
//  Created by Ольга Чушева on 06.05.2024.
//

import Foundation
import UIKit

final class LoaderView: UIView, LoadingView {

    var activityIndicator = UIActivityIndicatorView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(activityIndicator)
        activityIndicator.constraintCenters(to: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
