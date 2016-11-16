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
  
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard string.characters.count > 0 else {
      return true
    }
    // if textfields are of AllowedCharactersTextField class, this will allow them to only use provided characters in Interface builder
    if let textField = textField as? AllowedCharactersTextField {
      let currentText = textField.text ?? ""
      let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
      return prospectiveText.containsOnlyCharacters(matchCharacters: textField.allowedCharacters)
    } else {
      return true
    }
  }
  
  // require fields to be at least 2 characters before accepting return key
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    guard (textField.text?.characters.count)! >= 2 else {
      return false
    }
    textField.resignFirstResponder()
    return true
  }
}
