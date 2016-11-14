//
//  TemporaryType.swift
//  AmusementparkPassGeneratorPart2
//
//  Created by Katherine Ebel on 11/10/16.
//  Copyright © 2016 Katherine Ebel. All rights reserved.
//

import Foundation

enum TemporaryType: ParkEntrant, Contactable {
  case vendor(info: VendorVisitInformation, accessAreas: [AccessArea])
  case contractEmployee(info: ContractEmployeeInformation, accessAreas: [AccessArea])
  
}

extension TemporaryType {
  
  static func getRequiredFields(fromTitle title: String) -> [InformationField] {
    if let _ = Int(title) {
      return [.projectNumber, .firstName, .lastName, .streetAddress, .city, .state, .zipCode]
    } else {
      return [.dateOfBirth, .dateOfVisit, .firstName, .lastName, .companyName]
    }
  }
  var accessAreas: [AccessArea] {
    switch self {
    case .contractEmployee(info: _, accessAreas: let areas): return areas
    case .vendor(info: _, accessAreas: let areas): return areas
    }
  }
  
  var rideAccess: (allRides: Bool, skipsQueues: Bool) {
    return (false, false)
  }
  // returns instance of ContactInformation for an instance of manager type
  var contactInformation: Contactable {
    switch self {
      case .vendor(info: let info): return info as! Contactable
      case .contractEmployee(info: let info, accessAreas: _): return info as Contactable
    }
  }
  
  var contactDetails: String {
    switch self {
    case .contractEmployee(info: let contractEmployee):
      return contractEmployee.info.contactDetails
    case .vendor(info: let vendorVisit):
      return vendorVisit.info.contactDetails
    }
  }
}
