import UIKit

import UIKit

/// Параметры для отображения выделенной коллекции.
struct FeaturedCollectionParameters {
    // MARK: - Public Properties
    
    /// Количество ячеек в коллекции.
    let cellCount: Int
    /// Отступ слева от края коллекции.
    let leftInset: CGFloat
    /// Отступ справа от края коллекции.
    let rightInset: CGFloat
    /// Расстояние между ячейками в коллекции.
    let cellSpacing: CGFloat
    /// Общая ширина отступов и промежутков для вычисления ширины коллекции.
    let paddingWidth: CGFloat
    
    // MARK: - Life Cycle
    
    /// Инициализатор параметров выделенной коллекции.
    ///
    /// - Parameters:
    ///   - cellCount: Количество ячеек в коллекции.
    ///   - leftInset: Отступ слева от края коллекции.
    ///   - rightInset: Отступ справа от края коллекции.
    ///   - cellSpacing: Расстояние между ячейками в коллекции.
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
        self.paddingWidth = leftInset + rightInset + (CGFloat(cellCount - 1) * cellSpacing)
    }
}
