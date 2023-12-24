//
//  CollectionSettings.swift
//  FakeNFT
//
//  Created by Alexandr Seva on 15.12.2023.
//

import Foundation

struct CollectionSettings {
    let cellCount: Int
    let topDistance: CGFloat
    let bottomDistance: CGFloat
    let leftDistance: CGFloat
    let rightDistance: CGFloat
    let cellSpacing: CGFloat
    let paddingWidth: CGFloat

    init(
        cellCount: Int,
        topDistance: CGFloat,
        bottomDistance: CGFloat,
        leftDistance: CGFloat,
        rightDistance: CGFloat,
        cellSpacing: CGFloat
    ) {
        self.cellCount = cellCount
        self.topDistance = topDistance
        self.bottomDistance = bottomDistance
        self.leftDistance = leftDistance
        self.rightDistance = rightDistance
        self.cellSpacing = cellSpacing
        self.paddingWidth = leftDistance + rightDistance + CGFloat(cellCount - 1) * cellSpacing
    }
}
