//
//  Parser.swift
//  SudokuSolver
//
//  Created by William Green on 2017-02-11.
//  Copyright © 2017 William Green. All rights reserved.
//

import Foundation

enum ParserError: Error {
    case InvalidNumberOfRows
    case InvalidNumberOfColumns
    case InvalidCharacter
    case InvalidBoard
}

class Parser {
    static func parse(string: String) throws -> Board {
        var board = Board()

        let rows = string.components(separatedBy: "\n")
        guard rows.count == 9 else {
            throw ParserError.InvalidNumberOfRows
        }
        for (row, line) in rows.enumerated() {
            guard line.unicodeScalars.count == 9 else {
                throw ParserError.InvalidNumberOfColumns
            }
            for (col, char) in line.unicodeScalars.enumerated() {
                if char.value >= UnicodeScalar("1").value && char.value <= UnicodeScalar("9").value {
                    let num = char.value - UnicodeScalar("0").value
                    board[row, col] = Int(num)
                } else if char != "-" {
                    throw ParserError.InvalidCharacter
                }
            }
        }

        guard board.valid else {
            throw ParserError.InvalidBoard
        }

        return board
    }
}
