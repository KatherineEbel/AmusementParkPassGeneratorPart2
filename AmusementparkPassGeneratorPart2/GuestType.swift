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

enum GuestType: ParkEntrant, AgeVerifiable {
  case classic
  case VIP
  case freeChild(birthdate: BirthDate)
}

extension GuestType {
  // returns a named tuple for each GuestType case (accessed by discounts.food, discounts.merchandise)
  var discounts: (food: Percent, merchandise: Percent) {
    let foodDiscount = DiscountType.food(vipFoodDiscount).discount
    let merchandiseDiscount = DiscountType.merchandise(vipMerchandiseDicount).discount
    switch self {
    case .VIP: return (foodDiscount, merchandiseDiscount)
    default:
      return (0, 0)
    }
  }
  
  // returns a named tuple for each GuestType case (accessed by rideAccess.allRides, rideAccess.skipsQueues)
  var rideAccess: (allRides: Bool, skipsQueues: Bool) {
    switch self {
      case .VIP:
        let allRides = RideAccess.allRides(true).access
        let skipsQueues = RideAccess.skipsQueues(true).access
        return (allRides, skipsQueues)
      default:
        return (true, false)
    }
  }
}
