import UIKit

struct GeometricParams {
    let cellCount: Int
    let leftInset: CGFloat
    let rightInset: CGFloat
    let cellSpacing: CGSize
    let paddingWidth: CGFloat

    init(cellCount: Int, leftInset: CGFloat, rightInset: CGFloat, cellSpacing: CGSize) {
        self.cellCount = cellCount
        self.leftInset = leftInset
        self.rightInset = rightInset
        self.cellSpacing = cellSpacing
        self.paddingWidth = leftInset + rightInset + CGFloat(cellCount - 1) * cellSpacing.width
    }
}
