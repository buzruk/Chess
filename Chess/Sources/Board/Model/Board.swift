//
//  Board.swift
//  Chess
//
//  Created by Buzurgmexr Sultonaliyev on 28/09/23.
//

struct Board: Equatable {
  private(set) var pieces: [[Piece?]]
}

extension Board {
  static let allPositions = (0 ..< 8).flatMap { y in
    (0 ..< 8).map { Position(x: $0, y: y) }
  }

  var allPositions: [Position] { return Self.allPositions }

  var allPieces: [(position: Position, piece: Piece)] {
    return allPositions.compactMap { position in
      pieces[position.y][position.x].map { (position, $0) }
    }
  }

  init() {
    pieces = [
      ["Black Rook 0", "Black Knight 1", "Black Bishop 2", "Black Queen 3",
       "Black King 4", "Black Bishop 5", "Black Knight 6", "Black Rook 7"],
      ["Black Pawn 0", "Black Pawn 1", "Black Pawn 2", "Black Pawn 3",
       "Black Pawn 4", "Black Pawn 5", "Black Pawn 6", "Black Pawn 7"],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil, nil],
      ["White Pawn 0", "White Pawn 1", "White Pawn 2", "White Pawn 3",
       "White Pawn 4", "White Pawn 5", "White Pawn 6", "White Pawn 7"],
      ["White Rook 0", "White Knight 1", "White Bishop 2", "White Queen 3",
       "White King 4", "White Bishop 5", "White Knight 6", "White Rook 7"],
    ]
  }

  func piece(at position: Position) -> Piece? {
    guard (0 ..< 8).contains(position.y), (0 ..< 8).contains(position.x) else {
      return nil
    }
    return pieces[position.y][position.x]
  }

  func firstPosition(where condition: (Piece) -> Bool) -> Position? {
    return allPieces.first(where: { condition($1) })?.position
  }

  mutating func movePiece(from: Position, to: Position) {
    var pieces = self.pieces
    pieces[to.y][to.x] = piece(at: from)
    pieces[from.y][from.x] = nil
    self.pieces = pieces
  }

  mutating func removePiece(at position: Position) {
    var pieces = self.pieces
    pieces[position.y][position.x] = nil
    self.pieces = pieces
  }

  mutating func promotePiece(at position: Position, to type: PieceType) {
    var piece = self.piece(at: position)
    piece?.type = type
    pieces[position.y][position.x] = piece
  }
}

extension Board {
  func piecesExist(between: Position, and: Position) -> Bool {
    var x: Int
    var y: Int

    if between.x > and.x { x = -1 }
    else if between.x < and.x { x = 1 }
    else { x = 0 }

    if between.y > and.y { y = -1 }
    else if between.y < and.y { y = 1 }
    else { y = 0 }

    let step = Delta(x: x, y: y)

    //    let step = Delta(
    //      x: between.x > and.x ? -1 : (between.x < and.x ? 1 : 0),
    //      y: between.y > and.y ? -1 : (between.y < and.y ? 1 : 0)
    //    )

    var position = between
    position += step
    while position != and {
      if piece(at: position) != nil {
        return true
      }
      position += step
    }
    return false
  }
}
