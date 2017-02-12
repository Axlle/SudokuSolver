//
//  NineSet.swift
//  SudokuSolver
//
//  Created by William Green on 2017-02-10.
//  Copyright © 2017 William Green. All rights reserved.
//

import Foundation

struct NineSet: Equatable, CustomStringConvertible {
    var nums: [Bool]

    static let empty = NineSet(full: false)
    static let full = NineSet(full: true)

    init() {
        self.init(full: false)
    }

    init(full: Bool) {
        nums = [Bool](repeating: full, count: 9)
    }

    func contains(_ num: Int) -> Bool {
        return nums[num - 1]
    }

    mutating func add(_ num: Int) {
        nums[num - 1] = true
    }

    mutating func remove(_ num: Int) {
        nums[num - 1] = false
    }

    mutating func removeAll() {
        nums = [Bool](repeating: false, count: 9)
    }

    public static func ==(lhs: NineSet, rhs: NineSet) -> Bool {
        return lhs.nums == rhs.nums
    }

    var description: String {
        var description = ""
        for i in 1...9 {
            description += nums[i - 1] ? "\(i)" : "-"
        }
        return description
    }
}
