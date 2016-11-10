//
//  CardReader.swift
//  AmusementParkPassGenerator
//
//  Created by Katherine Ebel on 11/5/16.
//  Copyright © 2016 Katherine Ebel. All rights reserved.
//

typealias AccessMessage = String
protocol CardReader {
  func areaAccess(forPass pass: PassType) -> AccessMessage
  func rideAccess(forPass pass: PassType) -> AccessMessage
  func discountAccess(forPass pass: PassType) -> AccessMessage
  func alertBirthday(forPass pass: PassType) -> AccessMessage
}

extension CardReader {
  func areaAccess(forPass pass: PassType) -> AccessMessage {
    let message: AccessMessage = "Card has access for: "
    let accessAreas = pass.accessAreas.map { (accessArea) -> String in
      accessArea.rawValue
    }
    if accessAreas.count > 1 {
      let prefix = accessAreas.prefix(accessAreas.count - 1)
      let suffix = accessAreas.suffix(1).first!
      return "\(message) \(prefix.joined(separator: " area, ")) and \(suffix) area"
    } else {
      return "\(message) \(accessAreas[0]) area"
    }
  }
  
  func rideAccess(forPass pass: PassType) -> AccessMessage {
    var message = "Pass has access to: "
    let allRideAccess = pass.allRideAccess
    let skipsQueues = pass.skipsQueues
    message += allRideAccess ? "All Rides" : ""
    if allRideAccess && skipsQueues {
      message += " ,and skips lines for queues"
    }
    return message
  }
  
  func discountAccess(forPass pass: PassType) -> AccessMessage {
    let foodDiscount = pass.foodDiscount
    let merchandiseDiscount = pass.merchandiseDiscount
    if foodDiscount == 0 && merchandiseDiscount == 0 {
      return "This pass is not eligible for any discounts"
    } else {
      return "This pass gets a food discount of \(foodDiscount)%, and a merchandise discount of \(merchandiseDiscount)%"
    }
  }
  
  func alertBirthday(forPass pass: PassType) -> AccessMessage {
    return ""
  }
  
}
