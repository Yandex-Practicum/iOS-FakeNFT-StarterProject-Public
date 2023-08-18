//
//  GeometricParams.swift
//  FakeNFT
//
//  Created by macOS on 23.06.2023.
//

import Foundation

public struct GeometricParams {
    let cellCount: Int
    let leftInset: CGFloat
    let rightInset: CGFloat
    let cellHorizontalSpacing: CGFloat
    let cellVerticalSpacing: CGFloat
    let paddingWidth: CGFloat
    
    public init(cellCount: Int, leftInset: CGFloat, rightInset: CGFloat, cellHorizontalSpacing: CGFloat, cellVerticalSpacing: CGFloat) {
        self.cellCount = cellCount
        self.leftInset = leftInset
        self.rightInset = rightInset
        self.cellHorizontalSpacing = cellHorizontalSpacing
        self.cellVerticalSpacing = cellVerticalSpacing
        self.paddingWidth = leftInset + rightInset + CGFloat(cellCount - 1) * cellHorizontalSpacing
    }
}
