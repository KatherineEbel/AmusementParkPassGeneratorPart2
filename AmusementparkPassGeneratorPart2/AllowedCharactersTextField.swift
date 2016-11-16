//
//  AllowedCharactersTextField.swift
//  AmusementparkPassGeneratorPart2
//
//  Created by Katherine Ebel on 11/16/16.
//  Copyright © 2016 Katherine Ebel. All rights reserved.
//

import UIKit

class AllowedCharactersTextField: UITextField, UITextFieldDelegate {

  // able to adjust property in interface builder
  @IBInspectable var allowedCharacters: String = ""
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    autocorrectionType = .no
  }
}

// allows each textfield of this class to have it's own max length
private var maxLengths = [UITextField: Int]()

// this extension allows you to set different lengths for individual textFields
extension UITextField {
  @IBInspectable var maxLength: Int {
    get {
      guard let length = maxLengths[self] else {
        return Int.max
      }
      return length
    }
    set {
      maxLengths[self] = newValue
      addTarget(self, action: #selector(limitLength), for: .editingChanged)
    }
  }
  
  func limitLength(textField: UITextField) {
    guard let prospectiveText = textField.text, prospectiveText.characters.count > maxLength else {
      return
    }
    
    //let selection = selectedTextRange
    let index = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
    text = prospectiveText.substring(to: index)
    //selectedTextRange = selection
  }
}

// this extension lets a string check if it contains a certain characters
extension String {
  // Returns true if the string contains only characters found in match Characters.
  func containsOnlyCharacters(matchCharacters: String) -> Bool {
    let unallowedCharacterSet = CharacterSet(charactersIn: matchCharacters).inverted
    return self.rangeOfCharacter(from: unallowedCharacterSet) == nil
  }
}
