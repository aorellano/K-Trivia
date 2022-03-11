//
//  Array+Extensions.swift
//  KTrivia
//
//  Created by Alexis Orellano on 3/9/22.
//

import Foundation

extension Array where Element: Hashable {
    func removeDuplicates() -> Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}
