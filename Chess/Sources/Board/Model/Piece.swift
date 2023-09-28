//
//  Piece.swift
//  Chess
//
//  Created by Buzurgmexr Sultonaliyev on 28/09/23.
//

struct Piece: Equatable, ExpressibleByStringLiteral {
  let id: String
  var type: PieceType
  let color: Color

  var imageName: String {
    return "\(type.rawValue)_\(color.rawValue)"
  }

  init(stringLiteral: String) {
    id = stringLiteral
//    let chars = Array(stringLiteral)

//    precondition(chars.count == 3)

    let collection = stringLiteral.components(separatedBy: " ")
    precondition(collection.count == 3)

    let pieceColor = collection[0]
    let pieceType = collection[1]

    switch pieceColor {
    case "Black": color = .black
    case "White": color = .white
    default: preconditionFailure()
    }

    switch pieceType {
    case "Pawn": type = .pawn
    case "Rook": type = .rook
    case "Knight": type = .knight
    case "Bishop": type = .bishop
    case "Queen": type = .queen
    case "King": type = .king
    default: preconditionFailure()
    }
  }
}
