//
//  ChessColor.swift
//  Chess
//
//  Created by Buzurgmexr Sultonaliyev on 28/09/23.
//

enum ChessColor: String {
  case white
  case black

  var other: ChessColor {
    self == .black
      ? .white
      : .black
  }
}
