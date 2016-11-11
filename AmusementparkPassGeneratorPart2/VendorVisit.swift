//
//  VendorVisit.swift
//  AmusementparkPassGeneratorPart2
//
//  Created by Katherine Ebel on 11/10/16.
//  Copyright © 2016 Katherine Ebel. All rights reserved.
//

import Foundation

struct VendorVisitInformation: Contactable {
  let companyName: String
  let dateOfVisit: String //yyyy-MM-dd
  let dateOfBirth: BirthDate
  let contactInfo: ContactInformation
  var contactDetails: String {
    return "\(contactInfo.firstName) \(contactInfo.lastName) works for \(companyName)"
  }
}
