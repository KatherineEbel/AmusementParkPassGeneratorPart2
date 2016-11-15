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

extension VendorVisitInformation {
  init?(withInfo infoDict: [InformationField: String]) {
    if let companyName = infoDict[.companyName], let dateOfVisit = infoDict[.dateOfVisit],
      let dateOfBirth = infoDict[.dateOfBirth], let firstName = infoDict[.firstName],
      let lastName = infoDict[.lastName] {
      self.companyName = companyName
      self.dateOfVisit = dateOfVisit
      self.dateOfBirth = dateOfBirth
      self.contactInfo = ContactInformation(firstName: firstName, lastName: lastName)
    } else {
      return nil
    }
  }
}
