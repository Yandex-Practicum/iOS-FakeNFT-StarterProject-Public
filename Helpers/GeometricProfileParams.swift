import Foundation

struct GeometricProfileParams {
    let cellPerRowCount: CGFloat
    let cellSpacing: CGFloat
    let cellLeftInset: CGFloat
    let cellRightInset: CGFloat
    let cellHeight: CGFloat
    let paddingWight: CGFloat

    init(
        cellPerRowCount: CGFloat,
        cellSpacing: CGFloat,
        cellLeftInset: CGFloat,
        cellRightInset: CGFloat,
        cellHeight: CGFloat
    ) {
        self.cellPerRowCount = cellPerRowCount
        self.cellSpacing = cellSpacing
        self.cellLeftInset = cellLeftInset
        self.cellRightInset = cellRightInset
        self.cellHeight = cellHeight
        self.paddingWight = (cellPerRowCount - 1) * cellSpacing + cellLeftInset + cellRightInset
    }
}
