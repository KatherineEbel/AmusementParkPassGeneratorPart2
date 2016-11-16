//
//  RideAccess.swift
//  AmusementParkPassGenerator
//
//  Created by Katherine Ebel on 11/4/16.
//  Copyright © 2016 Katherine Ebel. All rights reserved.
//

// all ParkEntrant protocol adopters must have a property to get value for ride access
enum RideAccess {
  case allRides(Bool)
  case skipsQueues(Bool)
}

extension RideAccess {
  var access: Bool {
    switch self {
      case .allRides(let success): return success
      case .skipsQueues(let success): return success
    }
  }
}
