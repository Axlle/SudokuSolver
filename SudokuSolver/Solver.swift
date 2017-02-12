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
            let possibilities = Solver.possibilities(for: board)
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
                print(possibilities)
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

    static func reduce(board: Board, with possibilities: PossibilityBoard) -> Board {
        var reducedBoard = board

        for row in 0..<9 {
            for col in 0..<9 {
                guard board[row, col] == 0 else {
                    continue
                }

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
                }
            }
        }

        return reducedBoard
    }
}
