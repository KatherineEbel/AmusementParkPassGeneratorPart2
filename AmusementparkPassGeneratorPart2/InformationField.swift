//
//  InformationField.swift
//  AmusementparkPassGeneratorPart2
//
//  Created by Katherine Ebel on 11/13/16.
//  Copyright © 2016 Katherine Ebel. All rights reserved.
//

import Foundation

typealias Tag = Int
enum InformationField: Tag {
  case dateOfBirth = 101
  case dateOfVisit = 102
  case projectNumber = 103
  case firstName = 104
  case lastName = 105
  case companyName = 106
  case streetAddress = 107
  case city = 108
  case state = 109
  case zipCode = 110
}

extension InformationField {
  var name: String {
    switch self {
      case .dateOfBirth: return "dateOfBirth"
      case .dateOfVisit: return "dateOfVisit"
      case .projectNumber: return "projectNumber"
      case .firstName: return "firstName"
      case .lastName: return "lastName"
      case .companyName: return "companyName"
      case .streetAddress: return "streetAddress"
      case .city: return "city"
      case .state: return "state"
      case .zipCode: return "zipCode"
    }
  }
}
