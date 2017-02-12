//
//  Board.swift
//  SudokuSolver
//
//  Created by William Green on 2017-02-10.
//  Copyright © 2017 William Green. All rights reserved.
//

import Foundation

struct Board: Equatable, CustomStringConvertible {
    var cells: [Int]

    init() {
        cells = [Int](repeating: 0, count: 9 * 9)
    }

    subscript(row: Int, col: Int) -> Int {
        get {
            assert(row >= 0 && row < 9 && col >= 0 && col < 9)
            return cells[row * 9 + col]
        }

        set {
            assert(row >= 0 && row < 9 && col >= 0 && col < 9)
            assert(newValue > 0 && newValue <= 9)
            cells[row * 9 + col] = newValue
        }
    }

    var valid: Bool {

        // Horizontal lines
        for row in 0..<9 {
            var nineSet = NineSet()
            for col in 0..<9 {
                let num = self[row, col]
                if num != 0 {
                    if nineSet.contains(num) {
                        return false
                    }
                    nineSet.add(num)
                }
            }
        }

        // Vertical lines
        for col in 0..<9 {
            var nineSet = NineSet()
            for row in 0..<9 {
                let num = self[row, col]
                if num != 0 {
                    if nineSet.contains(num) {
                        return false
                    }
                    nineSet.add(num)
                }
            }
        }

        // Boxes
        for boxRow in 0..<3 {
            for boxCol in 0..<3 {
                var nineSet = NineSet()
                for cellRow in 0..<3 {
                    for cellCol in 0..<3 {
                        let num = self[boxRow * 3 + cellRow, boxCol * 3 + cellCol]
                        if num != 0 {
                            if nineSet.contains(num) {
                                return false
                            }
                            nineSet.add(num)
                        }
                    }
                }
            }
        }
        return true
    }

    var complete: Bool {
        for row in 0..<9 {
            for col in 0..<9 {
                if self[row, col] == 0 {
                    return false
                }
            }
        }
        return true
    }

    var solved: Bool {
        return valid && complete
    }

    public static func ==(lhs: Board, rhs: Board) -> Bool {
        return lhs.cells == rhs.cells
    }

    var description: String {
        var description = ""

        for row in 0..<9 {
            for col in 0..<9 {
                let cell = self[row, col]
                description += cell == 0 ? " " : "\(cell)"

                if col == 2 || col == 5 {
                    description += "|"
                }
            }
            
            description += "\n"
            
            if row == 2 || row == 5 {
                description += "---+---+---\n"
            }
        }
        
        return description
    }
}

struct PossibilityBoard: Equatable, CustomStringConvertible {
    var cells: [NineSet]

    init() {
        cells = [NineSet](repeating: NineSet.empty, count: 9 * 9)
    }

    subscript(row: Int, col: Int) -> NineSet {
        get {
            assert(row >= 0 && row < 9 && col >= 0 && col < 9)
            return cells[row * 9 + col]
        }
        set {
            assert(row >= 0 && row < 9 && col >= 0 && col < 9)
            cells[row * 9 + col] = newValue
        }
    }

    public static func ==(lhs: PossibilityBoard, rhs: PossibilityBoard) -> Bool {
        return lhs.cells == rhs.cells
    }

    var description: String {
        var description = ""

        for row in 0..<9 {
            for possibilityRow in 0..<3 {
                for col in 0..<9 {
                    for possibilityCol in 0..<3 {
                        let num = possibilityRow * 3 + possibilityCol + 1
                        description += self[row, col].contains(num) ? "\(num)" : "-"
                    }

                    if col == 2 || col == 5 {
                        description += " | "
                    } else if col == 8 {
                        description += "\n"
                    } else {
                        description += " "
                    }
                }
            }

            if row == 2 || row == 5 {
                description += "------------+-------------+------------\n"
            } else if row < 8 {
                description += "            |             |            \n"
            }
        }

        return description
    }
}

