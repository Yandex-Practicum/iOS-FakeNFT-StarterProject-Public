import UIKit

struct FeaturedCollectionParameters {
    // MARK: - Public proprties
    
    let cellCount: Int
    let leftInset: CGFloat
    let rightInset: CGFloat
    let cellSpacing: CGFloat
    let paddingWidth: CGFloat
    
    // MARK: - Life cycle
    
    init(
        cellCount: Int,
        leftInset: CGFloat,
        rightInset: CGFloat,
        cellSpacing: CGFloat
    ) {
        self.cellCount = cellCount
        self.leftInset = leftInset
        self.rightInset = rightInset
        self.cellSpacing = cellSpacing
        self.paddingWidth = leftInset + rightInset + CGFloat(cellCount - 1) * cellSpacing
    }
}
