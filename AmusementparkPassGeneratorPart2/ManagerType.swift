//
//  ManagerType.swift
//  AmusementParkPassGenerator
//
//  Created by Katherine Ebel on 11/3/16.
//  Copyright © 2016 Katherine Ebel. All rights reserved.
//

import Foundation

// private constants for manager discounts
fileprivate let managerFoodDiscount: Percent = 25
fileprivate let managerMerchandiseDiscount: Percent = 25

// kept manager as it's own type to leave open to adding more types...
enum ManagerType: ParkEntrant, Contactable {
  case manager(contactInfo: ContactInformation)
}

extension ManagerType {
  
  // given a subtype and required info, return a ManagerType
  static func managerType(forSubType type: SubType, withInfo info: [InformationField: String]) -> ManagerType? {
    if let contactInformation = ContactInformation(withDictionary: info) {
      return ManagerType.manager(contactInfo: contactInformation)
    } else {
      return nil
    }
  }
  
  static var allTypes: [String] {
    return ["General Manager"]
  }
  static func getRequiredFields() -> [InformationField] {
    return [.firstName, .lastName, .streetAddress, .city, .state, .zipCode]
  }
  
  var subType: SubType {
    switch self {
      case .manager: return "General Manager"
    }
  }
  
  // returns a named tuple for each GuestType case (accessed by discounts.food, discounts.merchandise)
  var discounts: (food: Percent, merchandise: Percent) {
    let foodDiscount = DiscountType.food(managerFoodDiscount).discount
    let merchandiseDiscount = DiscountType.merchandise(managerMerchandiseDiscount).discount
    return (foodDiscount, merchandiseDiscount)
  }
  
  // returns a named tuple for each GuestType case (accessed by rideAccess.allRides, rideAccess.skipsQueues)
  var accessAreas: [AccessArea] {
    return [.amusement, .kitchen, .maintenance, .rideControl, .office]
  }
  
  // returns instance of ContactInformation for an instance of manager type
  var contactInformation: ContactInformation {
    switch self {
      case .manager(let contactInformation): return contactInformation
    }
  }
  
  // returns printable description of contact information
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
