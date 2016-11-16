//
//  AccessArea.swift
//  AmusementParkPassGenerator
//
//  Created by Katherine Ebel on 11/4/16.
//  Copyright © 2016 Katherine Ebel. All rights reserved.
//

// park entrants have an array of one or more areas they have access to
enum AccessArea: String {
  case amusement
  case kitchen
  case rideControl = "Ride Control"
  case maintenance
  case office
}
