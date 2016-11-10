//
//  AccessPass.swift
//  AmusementParkPassGenerator
//
//  Created by Katherine Ebel on 11/3/16.
//  Copyright © 2016 Katherine Ebel. All rights reserved.
//

import Foundation

fileprivate let seniorAge: Double = 65

// AccessPass struct is located in the AccessPassGenerator class
extension AccessPassGenerator.AccessPass {
  // returns foodDiscount for instance of pass
  var foodDiscount: Percent {
    let foodDiscount = type.discounts.food
    return foodDiscount
  }
  
  // returns merchandiseDiscount for instance of pass
  var merchandiseDiscount: Percent {
    return type.discounts.merchandise
  }
  
  // returns true if pass has access to all rides
  var allRideAccess: Bool {
    return type.rideAccess.allRides
  }
  
  // returns true if pass has access to skip line for rides
  var skipsQueues: Bool {
    return type.rideAccess.skipsQueues
  }
  
  // returns array of all access areas
  var accessAreas: [AccessArea] {
    return type.accessAreas
  }
  
  // returns true if instance of pass has access to given area
  func hasAccess(toArea area: AccessArea) -> Bool {
    return accessAreas.contains(area)
  }
  
  // not all passes contain contact info so returns optional contact info
  var contactInfo: ContactInformation? {
    switch type {
    case is HourlyEmployeeType:
      let employeeType = type as! HourlyEmployeeType
      return employeeType.contactInformation
    case is ManagerType:
      let managerType = type as! ManagerType
      return managerType.contactInformation
    default:
      return nil
    }
  }
  
  // gets contact details for types that have it, or just
  // returns message that guest has no details
  var contactDetails: String {
    if let _ = contactInfo {
      if type is Contactable && type is HourlyEmployeeType {
        let hourlyEmployee = type as! HourlyEmployeeType
        return hourlyEmployee.contactDetails
      } else if type is Contactable && type is ManagerType {
        let manager = type as! ManagerType
        return manager.contactDetails
      }
    }
    return "Guest has no contact details"
  }
  
  // checks birthdate for age verifiable passes returns true if meets requirements
  var isVerified: Bool {
    if type is AgeVerifiable && type is GuestType {
      do {
        let verified: Bool
        switch type as! GuestType {
          case .freeChild(birthdate: let date):
            verified = try isValidChildAge(dateString: date)
          case .senior(birthdate: let date, contactInfo: _):
            verified = try isValidSeniorAge(dateString: date)
          default:
            return false
        }
        return verified
      } catch AccessPassError.FailsChildAgeRequirement(message: let message) {
          print(message)
      } catch AccessPassError.InvalidDateFormat(message: let message) {
          print(message)
      } catch let error {
          print("\(error)")
      }
    }
    return false
  }
}
