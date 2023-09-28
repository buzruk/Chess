//
//  BoardView.swift
//  Chess
//
//  Created by Buzurgmexr Sultonaliyev on 28/09/23.
//

import UIKit

protocol BoardViewDelegate: AnyObject {
  func boardView(_ boardView: BoardView, didTap position: Position)
}

class BoardView: UIView {
  weak var delegate: BoardViewDelegate?

  private(set) var squares: [UIImageView] = []
  private(set) var pieces: [String: UIImageView] = [:]
  private(set) var moveIndicators: [UIView] = []

  var board = Board() {
    didSet { updatePieces() }
  }

  var selection: Position? {
    didSet { updateSelection() }
  }

  var moves: [Position] = [] {
    didSet { updateMoveIndicators() }
  }

  func jigglePiece(at position: Position) {
    if let piece = board.piece(at: position) {
      pieces[piece.id]?.jiggle()
    }
  }

  func pulsePiece(at position: Position, completion: (() -> Void)?) {
    if let piece = board.piece(at: position) {
      pieces[piece.id]?.pulse(completion: completion)
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    sharedSetup()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    sharedSetup()
  }

  private func sharedSetup() {
    for y in 0 ..< 8 {
      for x in 0 ..< 8 {
        let white = x % 2 == y % 2
        let image = UIImage(named: white ? "square_white" : "square_black")
        let imageView = UIImageView(image: image)
        squares.append(imageView)
        addSubview(imageView)
      }
    }

    for row in board.pieces {
      for piece in row {
        guard let piece else { continue }
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        pieces[piece.id] = imageView
        addSubview(imageView)
      }
    }

    for _ in 0 ..< 8 {
      for _ in 0 ..< 8 {
        let view = UIView()
//        view.backgroundColor = .white
        moveIndicators.append(view)
        addSubview(view)
      }
    }

    let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
    addGestureRecognizer(tap)
  }

  @objc private func didTap(_ gesture: UITapGestureRecognizer) {
    let size = squareSize
    let location = gesture.location(in: self)
    let position = Position(
      x: Int(location.x / size.width),
      y: Int(location.y / size.height)
    )
    delegate?.boardView(self, didTap: position)
  }

  private func updatePieces() {
    var pieceIDs = Set<String>()
    let size = squareSize
    for (y, row) in board.pieces.enumerated() {
      for (x, piece) in row.enumerated() {
        guard let piece = piece, let view = pieces[piece.id] else {
          continue
        }
        pieceIDs.insert(piece.id)
        view.image = UIImage(named: piece.imageName)
        view.frame = frame(x: x, y: y, size: size)
        view.layer.transform = CATransform3DMakeScale(0.8, 0.8, 0)
      }
    }
    for (id, view) in pieces where !pieceIDs.contains(id) {
      view.alpha = 0
    }
    updateSelection()
  }

  private func updateSelection() {
    for (y, row) in board.pieces.enumerated() {
      for (x, piece) in row.enumerated() {
        guard let piece, let view = pieces[piece.id]
        else { continue }
        view.alpha = selection == Position(x: x, y: y) ? 0.5 : 1
      }
    }
  }

  private func updateMoveIndicators() {
    let size = squareSize
    for y in 0 ..< 8 {
      for x in 0 ..< 8 {
        let position = Position(x: x, y: y)
        let view = moveIndicators[y * 8 + x]
        view.frame = frame(x: x, y: y, size: size)
        view.layer.cornerRadius = 5
        view.layer.transform = CATransform3DMakeScale(0.9, 0.9, 0)
        view.layer.borderColor = UIColor(named: "indicator_border")?.cgColor
        view.layer.borderWidth = 2
        view.alpha = moves.contains(position) ? 0.5 : 0
      }
    }
  }

  private var squareSize: CGSize {
    let bounds = self.bounds.size
    return CGSize(width: ceil(bounds.width / 8), height: ceil(frame.height / 8))
  }

  private func frame(x: Int, y: Int, size: CGSize) -> CGRect {
    let offset = CGPoint(x: CGFloat(x) * size.width, y: CGFloat(y) * size.height)
    return CGRect(origin: offset, size: size)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    let size = squareSize
    for y in 0 ..< 8 {
      for x in 0 ..< 8 {
        squares[y * 8 + x].frame = frame(x: x, y: y, size: size)
      }
    }
    updatePieces()
    updateMoveIndicators()
  }
}
