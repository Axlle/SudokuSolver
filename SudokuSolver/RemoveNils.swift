//
//  RemoveNils.swift
//  SudokuSolver
//
//  Created by William Green on 2017-02-05.
//  Copyright © 2017 William Green. All rights reserved.
//

import Foundation

// http://stackoverflow.com/questions/28190631/creating-an-extension-to-filter-nils-from-an-array-in-swift/38548106#38548106
protocol OptionalType {
    associatedtype Wrapped
    func map<U>(_ f: (Wrapped) throws -> U) rethrows -> U?
}

extension Optional: OptionalType {}

extension Sequence where Iterator.Element: OptionalType {
    func removeNils() -> [Iterator.Element.Wrapped] {
        var result: [Iterator.Element.Wrapped] = []
        for element in self {
            if let element = element.map({ $0 }) {
                result.append(element)
            }
        }
        return result
    }
}
