//
//  Helper.swift
//  Chess
//
//  Created by Buzurgmexr Sultonaliyev on 28/09/23.
//

import UIKit

class Helper {
  static func alert(
    title: String?,
    message: String?,
    actions: [UIAlertAction]
  ) -> UIAlertController {
    let alert = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .alert
    )

    for action in actions {
      alert.addAction(action)
    }

    return alert
  }

  static func alertAction(
    isCancelAction: Bool = false,
    title: String? = nil,
    style: UIAlertAction.Style = .default,
    handler: ((UIAlertAction) -> Void)? = nil
  ) -> UIAlertAction {
    if isCancelAction {
      return UIAlertAction(title: "Cancel", style: .cancel)
    } else {
      return UIAlertAction(title: title, style: style, handler: handler)
    }
  }

  static func animate(
    withDuration: TimeInterval = 0.6,
    delay: TimeInterval = 0,
    usingSpringWithDamping: CGFloat = 0.8,
    initialSpringVelocity: CGFloat = 1,
    options: UIView.AnimationOptions = .curveEaseOut,
    animations: @escaping () -> Void,
    completion: ((Bool) -> Void)? = nil
  ) {
    UIView.animate(
      withDuration: withDuration,
      delay: delay,
      usingSpringWithDamping: usingSpringWithDamping,
      initialSpringVelocity: initialSpringVelocity,
      options: .curveEaseOut,
      animations: animations,
      completion: completion
    )
  }
}
