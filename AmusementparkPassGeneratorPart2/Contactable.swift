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
    let (streetAddress, city) = (contactInformation.streetAddress, contactInformation.city)
    let (state, zipCode) = (contactInformation.state, contactInformation.zipCode)
    return "\(firstName) \(lastName) lives at \(streetAddress) \(city) \(state), \(zipCode)"
  }
}
