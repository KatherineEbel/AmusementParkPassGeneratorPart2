//
//  GuestType.swift
//  AmusementParkPassGenerator
//
//  Created by Katherine Ebel on 11/3/16.
//  Copyright © 2016 Katherine Ebel. All rights reserved.
//

import Foundation

private let vipFoodDiscount: Percent = 10
private let vipMerchandiseDicount: Percent = 20
private let seniorMerchandiseDiscount: Percent = 10

enum GuestType: ParkEntrant, AgeVerifiable, Contactable {
  case classic
  case VIP
  case freeChild(birthdate: BirthDate)
  case senior(birthdate: BirthDate, contactInfo: ContactInformation)
  case seasonPass(ContactInformation)
}

extension GuestType {
  
  static var allTypes: [String] {
    return ["Classic", "VIP", "Free Child", "Senior", "Season Pass"]
  }
  
  // returns a named tuple for each GuestType case (accessed by discounts.food, discounts.merchandise)
  var discounts: (food: Percent, merchandise: Percent) {
    let foodDiscount = DiscountType.food(vipFoodDiscount).discount
    let largeMerchandiseDiscount = DiscountType.merchandise(vipMerchandiseDicount).discount
    let smallMerchandiseDiscount = DiscountType.merchandise(seniorMerchandiseDiscount).discount
    switch self {
    case .VIP, .seasonPass: return (foodDiscount, largeMerchandiseDiscount)
    case .senior: return (foodDiscount, smallMerchandiseDiscount)
    default:
      return (0, 0)
    }
  }
  
  // returns a named tuple for each GuestType case (accessed by rideAccess.allRides, rideAccess.skipsQueues)
  var rideAccess: (allRides: Bool, skipsQueues: Bool) {
    switch self {
      case .VIP, .seasonPass, .senior:
        let allRides = RideAccess.allRides(true).access
        let skipsQueues = RideAccess.skipsQueues(true).access
        return (allRides, skipsQueues)
      default:
        return (true, false)
    }
  }
  
  var contactInformation: ContactInformation? {
    switch self {
      case .seasonPass(let information): return information
      case .senior(birthdate: _, contactInfo: let information): return information
      default: return nil
    }
  }
  
  var contactDetails: String {
    var details = ""
    if let information = self.contactInformation {
      let (firstName, lastName) = (information.firstName, information.lastName)
      details += "\(firstName) \(lastName)"
      if let streetAddress = information.streetAddress, let city = information.city,
        let state = information.state, let zipcode = information.zipCode {
        details += " lives at \(streetAddress) \(city), \(state), \(zipcode)"
      }
    }
    return details
  }
}
