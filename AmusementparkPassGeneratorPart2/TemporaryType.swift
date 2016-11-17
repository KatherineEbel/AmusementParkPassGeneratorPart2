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
  case contractEmployee(contactInfo: ContractEmployeeInformation, accessAreas: [AccessArea])
  
}

extension TemporaryType {
  
  static func temporaryType(forEntrantType type: EntrantType, withInfo info: [InformationField: String], accessAreas: [AccessArea]) -> TemporaryType? {
    var temporaryType: TemporaryType?
    switch type.rawValue {
      case "Vendor":
        if let vendorInfo = VendorVisitInformation(withInfo: info) {
          temporaryType = TemporaryType.vendor(info: vendorInfo, accessAreas: accessAreas)
        }
      case "Contractor":
        var infoDict = info
        if let projectNumber = infoDict.removeValue(forKey: .projectNumber), let contractorInfo = ContractEmployeeInformation(projectNumber: projectNumber, withInfo: infoDict) {
          temporaryType = TemporaryType.contractEmployee(contactInfo: contractorInfo, accessAreas: accessAreas)
        }
      default: return temporaryType
    }
    return temporaryType
  }
  
  static func getRequiredFields(forType type: EntrantType) -> [InformationField] {
    switch type {
      case .Contractor: return [.projectNumber, .firstName, .lastName, .streetAddress, .city, .state, .zipCode]
      case .Vendor: return [.dateOfBirth, .dateOfVisit, .firstName, .lastName, .companyName]
      default: return []
    }
  }
  
  var subType: SubType {
    switch self {
      case .vendor: return "Vendor"
      case .contractEmployee: return "Contractor"
    }
  }
  
  var accessAreas: [AccessArea] {
      switch self {
        case .vendor(info: _, accessAreas: let areas): return areas
        case .contractEmployee(contactInfo: _, accessAreas: let areas): return areas
      }
  }
  
  // no ride access for either temporary type
  var rideAccess: (allRides: Bool, skipsQueues: Bool) {
    return (false, false)
  }
  // returns instance of ContactInformation for an instance of temporaryType
  var contactInformation: ContactInformation {
    switch self {
      case .vendor(info: let info, accessAreas: _): return info.contactInfo
      case .contractEmployee(contactInfo: let info, accessAreas: _): return info
    }
  }
  
  // returns a string representation of contact info
  var contactDetails: String {
    switch self {
    case .vendor(info: let vendorVisit):
      return vendorVisit.info.contactDetails
    case .contractEmployee(contactInfo: let contractEmployee):
      return contractEmployee.contactInfo.contactDetails
    }
  }
}
