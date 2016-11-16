//
//  EntrantTypeButton.swift
//  AmusementparkPassGeneratorPart2
//
//  Created by Katherine Ebel on 11/13/16.
//  Copyright © 2016 Katherine Ebel. All rights reserved.
//

import UIKit

class EntrantTypeButton: UIButton {
  
  let type: ParkEntrant? = nil
  
  
  override func awakeFromNib() {
    tintColor = UIColor(red: 135/255.0, green: 126/255.0, blue: 145/255.0, alpha: 1.0)
  }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
