//
//  ViewController.swift
//  Chess
//
//  Created by Buzurgmexr Sultonaliyev on 28/09/23.
//

import UIKit

class GameVC: UIViewController {
  private var game = Game()

  @IBOutlet var boardView: BoardView!
  @IBOutlet var blackToggle: UISegmentedControl!
  @IBOutlet var whiteToggle: UISegmentedControl!

  override func viewDidLoad() {
    super.viewDidLoad()
    boardView?.delegate = self
    update()
  }

//  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//    return .portrait
//  }

  @IBAction private func togglePlayerType() {
    makeComputerMove()
  }

  @IBAction private func resetGame() {
    let okAction = Helper.alertAction(title: "Ok") { _ in
      self.game = Game()
      Helper.animate(withDuration: 0.4) {
        self.boardView?.board = self.game.board
      } completion: { [weak self] _ in
        self?.update()
      }
      self.setSelection(nil)
    }

    let cancelAction = Helper.alertAction(isCancelAction: true)

    let alert = Helper.alert(
      title: "Are you sure you want to reset game?",
      message: nil,
      actions: [okAction, cancelAction]
    )

    present(alert, animated: true)
  }
}

extension GameVC: BoardViewDelegate {
  func boardView(_ boardView: BoardView, didTap position: Position) {
    guard let selection = boardView.selection else {
      if game.canSelectPiece(at: position) {
        setSelection(position)
      } else {
        boardView.jigglePiece(at: position)
      }
      return
    }

    guard game.canMove(from: selection, to: position) else {
      if selection == position {
        setSelection(nil)
      } else if game.canSelectPiece(at: position) {
        setSelection(position)
      }
      return
    }

    makeMove(Move(from: selection, to: position))
  }

  private func playerIsHuman(_ color: ChessColor) -> Bool {
    switch color {
    case .white:
      return whiteToggle?.selectedSegmentIndex == 0
    case .black:
      return blackToggle?.selectedSegmentIndex == 0
    }
  }

  private func update() {
    let gameState = game.state
    switch gameState {
    case .checkMate, .staleMate:
      let okAction = Helper.alertAction(title: "Ok") { _ in
        self.game = Game()

        Helper.animate {
          self.boardView?.board = self.game.board
        } completion: { [weak self] _ in
          self?.update()
        }

        self.setSelection(nil)
      }

      let alert = Helper.alert(
        title: "Game Over",
        message: gameState == .staleMate
          ? "Stalemate: Nobody wins"
          : "Checkmate: \(game.turn.other) wins",
        actions: [okAction]
      )

      present(alert, animated: true)
    case .check:
      boardView?.pulsePiece(at: game.kingPosition(for: game.turn)) {
        self.makeComputerMove()
      }
    case .idle:
      makeComputerMove()
    }
  }

  private func setSelection(_ position: Position?) {
    let moves = position.map(game.movesForPiece(at:)) ?? []
    Helper.animate(withDuration: 0.2) {
      self.boardView?.selection = position
      self.boardView?.moves = moves
    }
  }

  private func makeComputerMove() {
    if !playerIsHuman(game.turn),
       let move = game.nextMove(for: game.turn)
    {
      makeMove(move)
    }
  }

  private func makeMove(_ move: Move) {
    let position = move.to

    guard let boardView = boardView
    else { return }

    let oldGame = game
    game.move(from: move.from, to: position)
    let board1 = game.board
    let kingPosition = game.kingPosition(for: oldGame.turn)
    let wasInCheck = game.pieceIsThreatened(at: kingPosition)
    let wasPromoted = !wasInCheck && game.canPromotePiece(at: position)
    let wasHuman = playerIsHuman(oldGame.turn)

    if wasInCheck {
      game = oldGame
    }

    let board2 = game.board

    Helper.animate {
      boardView.selection = nil
      boardView.board = board1
      boardView.moves = []
    } completion: { [weak self] _ in
      guard let self, board2 == self.game.board else { return }
      if wasInCheck {
        Helper.animate(withDuration: 0.2) {
          boardView.board = board2
        }
        boardView.jigglePiece(at: kingPosition)
        return
      }
      if wasPromoted {
        if !wasHuman {
          self.game.promotePiece(at: position, to: .queen)
          let board2 = self.game.board

          Helper.animate {
            boardView.board = board2
          } completion: { [weak self] _ in
            guard board2 == self?.game.board else { return }
            self?.update()
          }
          return
        }

        var actions: [UIAlertAction] = []
        for piece in [PieceType.queen, .rook, .bishop, .knight] {
          actions.append(
            UIAlertAction(
              title: piece.rawValue.capitalized,
              style: .default
            ) { [weak self] _ in
              guard let self = self else { return }
              self.game.promotePiece(at: position, to: piece)
              boardView.board = self.game.board
              self.update()
            }
          )
        }

        let alert = Helper.alert(title: "Promote Pawn", message: nil, actions: actions)

        self.present(alert, animated: true)
      }
      self.update()
    }
  }
}
