//
//  UIImageView+Extension.swift
//  Chess
//
//  Created by Buzurgmexr Sultonaliyev on 28/09/23.
//

import UIKit

extension UIImageView {
  func pulse(
    scale: CGFloat = 1.5,
    duration: TimeInterval = 0.6,
    completion: (() -> Void)? = nil
  ) {
    let pulseView = UIImageView(frame: frame)
    pulseView.image = image
    superview?.addSubview(pulseView)

    Helper.animate {
      pulseView.transform = .init(scaleX: 2, y: 2)
      pulseView.alpha = 0
    } completion: { _ in
      pulseView.removeFromSuperview()
      completion?()
    }
  }
}
