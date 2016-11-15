//
//  RoundedView.swift
//  AmusementparkPassGeneratorPart2
//
//  Created by Katherine Ebel on 11/15/16.
//  Copyright © 2016 Katherine Ebel. All rights reserved.
//

import UIKit

extension UIView {
  @IBInspectable var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.cornerRadius = newValue
      layer.masksToBounds = newValue > 0
    }
  }
}
