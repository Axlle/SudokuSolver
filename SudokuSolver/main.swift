//
//  main.swift
//  SudokuSolver
//
//  Created by William Green on 2017-02-05.
//  Copyright © 2017 William Green. All rights reserved.
//

import Foundation

let deltaEasier = "1-65-2---\n--34--2--\n--4-9----\n4-2-1---3\n-61-2-84-\n5---3-1-2\n----8-4--\n--9--36--\n---2-79-1"
let deltaHarder = "6----2--4\n-5-3-4---\n-42-95-1-\n--47----2\n---416---\n9----87--\n-6-24-13-\n---9-1-7-\n1--8----6" // unsolved
let dd  = "--2-6---9\n6--4-9---\n54-2---6-\n28----95-\n---178---\n-67----81\n-2---1-94\n---8-4--5\n1---5-6--"
let aa1 = "----6--3-\n7--3--62-\n6---9--41\n---9--384\n---------\n174--8---\n34--2---6\n-85--3--7\n-6--4----"
let aa2 = "-5-8-----\n----3-2--\n-861---74\n------34-\n--34-95--\n-75------\n59---372-\n--1-8----\n-----2-1-"
let cc1 = "-9-----43\n------7--\n1--294-8-\n----596-7\n---------\n5-917----\n-2-618--4\n--3------\n68-----2-" // unsolved
let cc2 = "-1----597\n52--3----\n7----48--\n---5--1-3\n--1-6-7--\n3-5--1---\n--46----8\n----2--64\n637----5-"
let cc3 = "---6179--\n67-9-----\n9----31--\n--91---58\n-8-----2-\n53---26--\n--82----7\n-----8-94\n--4395---"
let t1  = "-8-1-----\n-1-3--857\n-59--23--\n--8----91\n---------\n12----7--\n--36--57-\n574--9-2-\n-----5-3-"
let t2  = "---5-8---\n75-3-9-62\n-3-----7-\n-872-694-\n---------\n-134-758-\n-6-----9-\n12-9-5-34\n---1-2---"
let q   = "----1--75\n-5-4--6-3\n9----3--2\n----9---4\n---1-7---\n8---6----\n7--2----8\n5-8--9-6-\n29--3----" // unsolved
let w1  = "------2--\n8---1--67\n--74---9-\n--5-----8\n--13975--\n7-----9--\n-6---43--\n31--5---6\n--8------" // unsolved
let w2  = "--6--7---\n-8---934-\n-1------6\n29--4----\n---3-6---\n----5--82\n9------1-\n-415---6-\n---8--5--"
let j1  = "--3---78-\n---938---\n--1--7--2\n4--3-----\n3-2-8-4-9\n-----6--1\n2--7--1--\n---862---\n-67---2--"
let j2  = "--159----\n5------68\n---7-4-2-\n------84-\n-5--3--1-\n-18------\n-3-1-2---\n96------1\n----897--"
let solved = "123456789\n456789123\n789123456\n231564897\n564897231\n897231564\n312645978\n645978312\n978312645"

enum ParserError: Error {
    case InvalidNumberOfRows
    case InvalidNumberOfColumns
    case InvalidCharacter
    case InvalidBoard
}

func parseBoard(string: String) throws -> Board {
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

var b = try! parseBoard(string: j2)
print(b)
Solver.solve(board: b)
