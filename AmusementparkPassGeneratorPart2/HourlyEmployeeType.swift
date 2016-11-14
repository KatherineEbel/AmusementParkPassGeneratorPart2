//
//  HourlyEmployeeType.swift
//  AmusementParkPassGenerator
//
//  Created by Katherine Ebel on 11/3/16.
//  Copyright © 2016 Katherine Ebel. All rights reserved.
//

import Foundation


private let employeeFoodDiscount: Percent = 15
private let employeeMerchandiseDicount: Percent = 25

enum HourlyEmployeeType: ParkEntrant, Contactable {
  case foodServices(ContactInformation)
  case rideServices(ContactInformation)
  case maintenance(ContactInformation)
}

extension HourlyEmployeeType {
  
  static func employee(forType type: String, withInfo info: [InformationField: String]) -> HourlyEmployeeType? {
    var employee: HourlyEmployeeType? = nil
    if let contactInformation = ContactInformation(withDictionary: info) {
      switch type {
        case "Food Services": employee = HourlyEmployeeType.foodServices(contactInformation)
        case "Ride Services": employee = HourlyEmployeeType.rideServices(contactInformation)
        case "Maintenance": employee = HourlyEmployeeType.maintenance(contactInformation)
        default: return employee
      }
    }
    return employee
  }
  
  static var allTypes: [String] {
    return ["Food Services", "Ride Services", "Maintenance"]
  }
  
  static func getRequiredFields() -> [InformationField] {
    return [.firstName, .lastName, .streetAddress, .city, .state, .zipCode]
  }
  
  // returns array of areas that each type has access to
  var accessAreas: [AccessArea] {
    switch self {
    case .foodServices: return [.amusement, .kitchen]
    case .maintenance: return [.amusement, .kitchen, .rideControl, .maintenance]
    case .rideServices: return [.amusement, .rideControl]
    }
  }
  
  // returns named tuple for discount amounts
  var discounts: (food: Percent, merchandise: Percent) {
    let foodDiscount = DiscountType.food(employeeFoodDiscount).discount
    let merchandiseDiscount = DiscountType.merchandise(employeeMerchandiseDicount).discount
    return (foodDiscount, merchandiseDiscount)
  }
  
  
  // returns instance of ContactInformation for an instance of manager type
  var contactInformation: ContactInformation {
    switch self {
      case .foodServices(let contactInformation): return contactInformation
      case .maintenance(let contactInformation): return contactInformation
      case .rideServices(let contactInformation): return contactInformation
    }
  }
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
