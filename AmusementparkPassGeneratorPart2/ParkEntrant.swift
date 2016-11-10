//
//  ParkEntrant.swift
//  AmusementParkPassGenerator
//
//  Created by Katherine Ebel on 11/3/16.
//  Copyright © 2016 Katherine Ebel. All rights reserved.
//

import Foundation

protocol ParkEntrant {
  var accessAreas: [AccessArea] { get }
  var rideAccess: (allRides: Bool, skipsQueues: Bool) { get }
  var discounts: (food: Percent, merchandise: Percent) { get }
}

extension ParkEntrant {
  var accessAreas: [AccessArea] {
    return [.amusement]
  }
  
  var rideAccess: (allRides: Bool, skipsQueues: Bool) {
    let allRides = RideAccess.allRides(true).access
    let skipsQueues = RideAccess.skipsQueues(false).access
    return (allRides, skipsQueues)
  }
  
  var discounts: (food: Percent, merchandise: Percent) {
    return (0, 0)
  }
}

