//
//  Solver.swift
//  SudokuSolver
//
//  Created by William Green on 2017-02-10.
//  Copyright © 2017 William Green. All rights reserved.
//

import Foundation

class Solver {

    static func solve(board: Board) {
        var board = board

        var numberOfPasses = 0

        while true {
            numberOfPasses += 1
            print("Pass \(numberOfPasses):")

            let previousBoard = board

            // Find the possibilites and reduce them
            var possibilities = Solver.possibilities(for: board)
            while true {
                let previousPossibilities = possibilities
                possibilities = Solver.reduce(possibilities: possibilities)
                if possibilities == previousPossibilities {
                    break
                }
            }

            board = Solver.reduce(board: board, with: possibilities)
            print(board)

            if board.solved {
                print("solved!")
                break
            } else if !board.valid {
                print("invalid")
                break
            } else if board == previousBoard {
                print("no progress")
                break
            }
        }
    }

    static func possibilities(for board: Board) -> PossibilityBoard {
        var possibilities = PossibilityBoard()
        for row in 0..<9 {
            for col in 0..<9 {
                guard board[row, col] == 0 else {
                    continue
                }

                var nineSet = NineSet.full

                // Horizontal lines
                for otherCol in 0..<9 {
                    guard otherCol != col else {
                        continue
                    }

                    let num = board[row, otherCol]
                    if num != 0 {
                        nineSet.remove(num)
                    }
                }

                // Vertical lines
                for otherRow in 0..<9 {
                    guard otherRow != row else {
                        continue
                    }

                    let num = board[otherRow, col]
                    if num != 0 {
                        nineSet.remove(num)
                    }
                }

                // Boxes
                let boxRow = row / 3
                let boxCol = col / 3
                for cellRow in 0..<3 {
                    for cellCol in 0..<3 {
                        let otherRow = boxRow * 3 + cellRow
                        let otherCol = boxCol * 3 + cellCol
                        guard otherRow != row || otherCol != col else {
                            continue
                        }

                        let num = board[otherRow, otherCol]
                        if num != 0 {
                            nineSet.remove(num)
                        }
                    }
                }

                possibilities[row, col] = nineSet
            }
        }
        return possibilities
    }

    static func reduce(possibilities: PossibilityBoard) -> PossibilityBoard {
        var reducedPossibilities = possibilities

        enum LinePossibility {
            case NoLines
            case OneLine(line: Int)
            case MultipleLines

            mutating func add(line newLine: Int) {
                switch self {
                case .NoLines:
                    self = .OneLine(line: newLine)
                case .OneLine(line: let line):
                    if line != newLine {
                        self = .MultipleLines
                    }
                default:
                    break
                }
            }
        }

        for boxRow in 0..<3 {
            for boxCol in 0..<3 {
                for num in 1...9 {
                    var rowPossibility = LinePossibility.NoLines
                    var colPossibility = LinePossibility.NoLines

                    for cellRow in 0..<3 {
                        for cellCol in 0..<3 {
                            let row = boxRow * 3 + cellRow
                            let col = boxCol * 3 + cellCol
                            if possibilities[row, col].contains(num) {
                                rowPossibility.add(line: cellRow)
                                colPossibility.add(line: cellCol)
                            }
                        }
                    }

                    switch rowPossibility {
                    case .OneLine(line: let takenRow):
                        for col in 0..<9 {
                            guard col / 3 != boxCol else {
                                continue
                            }

                            let row = boxRow * 3 + takenRow
                            if reducedPossibilities[row, col].contains(num) {
                                print("removing possibility of \(num) at [\(row), \(col)] because the row will be taken by box [\(boxRow), \(boxCol)]")
                                reducedPossibilities[row, col].remove(num)
                            }
                        }
                    default:
                        break
                    }

                    switch colPossibility {
                    case .OneLine(line: let takenCol):
                        for row in 0..<9 {
                            guard row / 3 != boxRow else {
                                continue
                            }

                            let col = boxCol * 3 + takenCol
                            if reducedPossibilities[row, col].contains(num) {
                                print("removing possibility of \(num) at [\(row), \(col)] because the column will be taken by box [\(boxRow), \(boxCol)]")
                                reducedPossibilities[row, col].remove(num)
                            }
                        }
                    default:
                        break
                    }
                }
            }
        }

        return reducedPossibilities
    }

    static func reduce(board: Board, with possibilities: PossibilityBoard) -> Board {
        var reducedBoard = board

        for row in 0..<9 {
            for col in 0..<9 {
                for num in 1...9 {
                    guard possibilities[row, col].contains(num) else {
                        continue
                    }

                    // Horizontal lines
                    var uniqueInRow = true
                    for otherCol in 0..<9 {
                        guard otherCol != col else {
                            continue
                        }

                        if possibilities[row, otherCol].contains(num) {
                            uniqueInRow = false
                            break
                        }
                    }
                    if uniqueInRow {
                        print("inserting \(num) at [\(row), \(col)], because it is unique in the row")
                        reducedBoard[row, col] = num
                        break
                    }

                    // Vertical lines
                    var uniqueInColumn = true
                    for otherRow in 0..<9 {
                        guard otherRow != row else {
                            continue
                        }

                        if possibilities[otherRow, col].contains(num) {
                            uniqueInColumn = false
                            break
                        }
                    }
                    if uniqueInColumn {
                        print("inserting \(num) at [\(row), \(col)], because it is unique in the column")
                        reducedBoard[row, col] = num
                        break
                    }

                    // Boxes
                    var uniqueInBox = true
                    let boxRow = row / 3
                    let boxCol = col / 3
                    for cellRow in 0..<3 {
                        for cellCol in 0..<3 {
                            let otherRow = boxRow * 3 + cellRow
                            let otherCol = boxCol * 3 + cellCol
                            guard otherRow != row || otherCol != col else {
                                continue
                            }

                            if possibilities[otherRow, otherCol].contains(num) {
                                uniqueInBox = false
                                break
                            }
                        }
                        if !uniqueInBox {
                            break
                        }
                    }
                    if uniqueInBox {
                        print("inserting \(num) at [\(row), \(col)], because it is unique in the box")
                        reducedBoard[row, col] = num
                        break
                    }

                    // Cells
                    var lastInCell = true
                    for otherNum in 1...9 {
                        guard otherNum != num else {
                            continue
                        }

                        if possibilities[row, col].contains(otherNum) {
                            lastInCell = false
                            break
                        }
                    }
                    if lastInCell {
                        print("inserting \(num) at [\(row), \(col)], because it is last remaining in the cell")
                        reducedBoard[row, col] = num
                        break
                    }
                }
            }
        }

        return reducedBoard
    }
}
