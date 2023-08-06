//
//  Changeset.swift
//  FakeNFT
//
//  Created by Aleksandr Bekrenev on 06.08.2023.
//

import Foundation

struct Changeset<T: Equatable> {
    var deletions: [IndexPath] = []
    var insertions: [IndexPath] = []

    init(oldItems: [T], newItems: [T]) {
        let difference = newItems.difference(from: oldItems)

        for change in difference {
            switch change {
            case .remove(let offset, _, _):
                self.deletions.append(IndexPath(row: offset, section: 0))
            case .insert(let offset, _, _):
                self.insertions.append(IndexPath(row: offset, section: 0))
            }
        }
    }
}
