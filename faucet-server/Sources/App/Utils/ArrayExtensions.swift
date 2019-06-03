//
//  ArrayExtensions.swift
//  App
//
//  Created by 翟泉 on 2019/5/27.
//

import Foundation

extension Array where Element: Equatable {
    @discardableResult
    mutating func remove(at item: Element) -> Element?  {
        if let index = firstIndex(where: { $0 == item }) {
            return remove(at: index)
        }
        return nil
    }
}
