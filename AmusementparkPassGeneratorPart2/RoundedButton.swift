//
//  RoundedButton.swift
//  AmusementparkPassGeneratorPart2
//
//  Created by Katherine Ebel on 11/13/16.
//  Copyright © 2016 Katherine Ebel. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
  override func awakeFromNib() {
    layer.cornerRadius = 5.0
  }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
