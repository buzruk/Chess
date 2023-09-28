//
//  PieceType.swift
//  Chess
//
//  Created by Buzurgmexr Sultonaliyev on 28/09/23.
//

enum PieceType: String {
  /// Moves one square forward,
  /// but on its first move, it can move two squares forward.
  /// It captures diagonally one square forward.
  case pawn

  /// Moves any number of squares horizontally or vertically.
  case rook

  /// Moves in an ‘L-shape,’ two squares in a straight direction,
  /// and then one square perpendicular to that.
  case knight

  /// Moves any number of squares diagonally.
  case bishop

  /// Moves any number of squares diagonally, horizontally, or vertically.
  case queen

  /// Moves one square in any direction.
  case king

  var value: Int {
    switch self {
    case .pawn: return 1
    case .knight, .bishop: return 3
    case .rook: return 5
    case .queen: return 9
    case .king: return 0
    }
  }
}
