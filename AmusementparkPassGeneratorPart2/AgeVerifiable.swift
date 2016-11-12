//
//  AgeVerifiable.swift
//  AmusementParkPassGenerator
//
//  Created by Katherine Ebel on 11/3/16.
//  Copyright © 2016 Katherine Ebel. All rights reserved.
//

import Foundation

// date format must be "yyyy-MM-dd"
typealias BirthDate = String
fileprivate let seniorAge: TimeInterval = 65

// Currently only GuestTypes are AgeVerifiable
protocol AgeVerifiable {
  var dateFormatter: DateFormatter { get }
  func years(fromSeconds seconds: TimeInterval) -> TimeInterval
  func ageFrom(dateString string: BirthDate) throws -> TimeInterval
  func isValidChildAge(dateString string: BirthDate) throws -> Bool
  func isValidSeniorAge(dateString string: BirthDate) throws -> Bool
}

extension AgeVerifiable {
  var dateFormatter: DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM-dd-yyyy"
    return dateFormatter
  }
  
  // converts passed in timeInterval (seconds) to number of years
  func years(fromSeconds seconds: TimeInterval) -> TimeInterval {
    // 60 sec per min 60 min per hour 24 hour per day avg 365.2425 day per year
    let (secPerMin, minPerHour): (Double, Double) = (60,60)
    let (hoursPerDay, daysPerYear): (Double, Double) = (24, 365.2425)
    let numSecInYear = secPerMin * minPerHour * hoursPerDay * daysPerYear
    return seconds / numSecInYear
  }
  
  func ageFrom(dateString string: BirthDate) throws -> TimeInterval {
    let today = Date()
    guard let birthdate = dateFormatter.date(from: string) else {
      throw AccessPassError.InvalidDateFormat(message: "Please enter date in format \"yyyy-mm-dd\"")
    }
    let timeInterval = today.timeIntervalSince(birthdate)
    return timeInterval
  }
  
  func isValidChildAge(dateString string: BirthDate) throws -> Bool {
    do {
      let age = try ageFrom(dateString: string)
      guard age < 5 else {
        throw AccessPassError.FailsChildAgeRequirement(message: "Child does not meet age requirements for a free child pass\nPass converted to Classic Pass")
      }
      return age < 5
    }
  }
  
  func isValidSeniorAge(dateString string: BirthDate) throws -> Bool {
    do {
      let age = try ageFrom(dateString: string)
      guard age >= seniorAge else {
        throw AccessPassError.FailsSeniorAgeRequirement(message: "Guest does not meet age requirements for a Senior Pass.\nPass converted to Classic Pass")
      }
      return age >= seniorAge
    }
  }
}
