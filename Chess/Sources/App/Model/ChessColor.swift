//
//  ChessColor.swift
//  Chess
//
//  Created by Buzurgmexr Sultonaliyev on 28/09/23.
//

enum Color: String {
  case white
  case black

  var other: Color {
    self == .black
      ? .white
      : .black
  }
}
