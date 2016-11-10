//
//  ContactInformation.swift
//  AmusementParkPassGenerator
//
//  Created by Katherine Ebel on 11/3/16.
//  Copyright © 2016 Katherine Ebel. All rights reserved.
//

import Foundation

struct ContactInformation {
  var firstName: String
  var lastName: String
  var streetAddress: String?
  var city: String?
  var state: String?
  var zipCode: String?
}


extension ContactInformation {
  init(firstName: String, lastName: String) {
    self.firstName = firstName
    self.lastName = lastName
    self.streetAddress = nil
    self.city = nil
    self.state = nil
    self.zipCode = nil
  }
  
  init?(withDictionary info: [String: String]) {
    do {
      if let firstName = info["firstName"], let lastName = info["lastName"],
        let streetAddress = info["streetAddress"], let city = info["city"],
        let state = info["state"], let zipCode = info["zipCode"] {
        self.init(firstName: firstName, lastName: lastName, streetAddress: streetAddress,
                  city: city, state: state, zipCode: zipCode)
      } else {
        throw AccessPassError.InvalidContactInfoProvided(message: "Invalid Information: Valid contact information includes: First name, last name, street address, city, state, and zipcode")
      }
    } catch AccessPassError.InvalidContactInfoProvided(message: let message) {
      print(message)
      return nil
    } catch let error {
      fatalError("\(error)")
    }
  }
}
