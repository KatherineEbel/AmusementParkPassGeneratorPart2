//
//  ContactInformation.swift
//  AmusementParkPassGenerator
//
//  Created by Katherine Ebel on 11/3/16.
//  Copyright © 2016 Katherine Ebel. All rights reserved.
//

import Foundation

class ContactInformation: Contactable {
  var firstName: String
  var lastName: String
  var streetAddress: String?
  var city: String?
  var state: String?
  var zipCode: String?
  
  init(firstName: String, lastName: String, streetAddress: String?, city: String?, state: String?, zipCode: String?) {
    self.firstName = firstName
    self.lastName = lastName
    if let streetAddress = streetAddress, let city = city,
      let state = state, let zipCode = zipCode {
      self.streetAddress = streetAddress
      self.city = city
      self.state = state
      self.zipCode = zipCode
    }
  }
  
  init?(withDictionary info: [InformationField: String]) {
   do {
    // fail early if empty values included
    guard !ContactInformation.hasEmptyValues(infoDictionary: info) else {
      throw AccessPassError.InvalidContactInfoProvided(message: "Empty values cannot be accepted")
    }
     if let firstName = info[.firstName], let lastName = info[.lastName],
       let streetAddress = info[.streetAddress], let city = info[.city],
       let state = info[.state], let zipCode = info[.zipCode] {
      self.firstName = firstName
      self.lastName = lastName
      self.streetAddress = streetAddress
      self.city = city
      self.state = state
      self.zipCode = zipCode
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


extension ContactInformation {
  convenience init(firstName: String, lastName: String) {
    self.init(firstName: firstName, lastName: lastName, streetAddress: nil, city: nil, state: nil, zipCode: nil)
  }
  
  static func hasEmptyValues(infoDictionary dict: [InformationField: String]) -> Bool {
    for (_, value) in dict {
      if value.isEmpty {
        return true
      }
    }
    return false
  }
  
  var contactDetails: String {
    let (firstName, lastName) = (self.firstName, self.lastName)
    if let streetAddress = self.streetAddress, let city = self.city,
      let state = self.state, let zipCode = self.zipCode {
      return "\(firstName) \(lastName) lives at \(streetAddress) \(city) \(state), \(zipCode)"
    } else {
      return "\(firstName) \(lastName)"
    }
  }
  
}
