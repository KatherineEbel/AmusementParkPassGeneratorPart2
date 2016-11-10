//
//  Contactable.swift
//  AmusementParkPassGenerator
//
//  Created by Katherine Ebel on 11/3/16.
//  Copyright © 2016 Katherine Ebel. All rights reserved.
//

import Foundation

protocol Contactable {
  var contactInformation: ContactInformation { get }
}

// adds contactDetails property
extension Contactable {
  // returns nice formatted details for a Contactable park entrant
  var contactDetails: String {
    let (firstName, lastName) = (contactInformation.firstName, contactInformation.lastName)
    if let streetAddress = contactInformation.streetAddress, let city = contactInformation.city,
      let state = contactInformation.state, let zipCode = contactInformation.zipCode {
      return "\(firstName) \(lastName) lives at \(streetAddress) \(city) \(state), \(zipCode)"
    } else {
      return "\(firstName) \(lastName)"
    }
  
  }
}
