//
//  ManagerType.swift
//  AmusementParkPassGenerator
//
//  Created by Katherine Ebel on 11/3/16.
//  Copyright © 2016 Katherine Ebel. All rights reserved.
//

import Foundation

// private constants for manager food discounts
fileprivate let managerFoodDiscount: Percent = 25
fileprivate let managerMerchandiseDiscount: Percent = 25

enum ManagerType: ParkEntrant, Contactable {
    case manager(ContactInformation)
}

extension ManagerType {
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
}
