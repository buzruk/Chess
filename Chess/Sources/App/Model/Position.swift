//
//  Position.swift
//  Chess
//
//  Created by Buzurgmexr Sultonaliyev on 28/09/23.
//

struct Position: Hashable {
  var x: Int
  var y: Int

  static func - (lhs: Position, rhs: Position) -> Delta {
    return Delta(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
  }

  static func + (lhs: Position, rhs: Delta) -> Position {
    return Position(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
  }

  static func += (lhs: inout Position, rhs: Delta) {
    lhs.x += rhs.x
    lhs.y += rhs.y
  }
}
