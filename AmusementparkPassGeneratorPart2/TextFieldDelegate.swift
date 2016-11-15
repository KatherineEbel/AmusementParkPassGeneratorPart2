//
//  TextFieldDelegate.swift
//  AmusementparkPassGeneratorPart2
//
//  Created by Katherine Ebel on 11/13/16.
//  Copyright © 2016 Katherine Ebel. All rights reserved.
//

import UIKit

extension CreatePassController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    if let currentTextField = (activeTextFields.filter { (key, value) in value == textField }).first {
      activeTextField = currentTextField.value
    }
  }
}
