//
//  AccessPassError.swift
//  AmusementParkPassGenerator
//
//  Created by Katherine Ebel on 11/3/16.
//  Copyright © 2016 Katherine Ebel. All rights reserved.
//

import Foundation

// Current main errors for incorrect contact information,
// incorrect date format
// failed to meet age requirement
enum AccessPassError: Error {
  case InvalidContactInfoProvided(message: String)
  case InvalidDateFormat(message: String)
  case FailsChildAgeRequirement(message: String)
  case FailsSeniorAgeRequirement(message: String)
  case InvalidProjectNumber(message: String)
  case InvalidVendor(message: String)
  case AccessSoundQueueError(message: String)
  case DoubleSwipeError(message: String)
}
