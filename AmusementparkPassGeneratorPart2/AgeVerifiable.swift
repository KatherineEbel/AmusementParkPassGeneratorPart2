//
//  AgeVerifiable.swift
//  AmusementParkPassGenerator
//
//  Created by Katherine Ebel on 11/3/16.
//  Copyright © 2016 Katherine Ebel. All rights reserved.
//

import Foundation

// date format must be "yyyy/MM/dd"
typealias BirthDate = String
private let seniorAge: TimeInterval = 65
private let maxChildAge: Double = 5

// Currently only GuestTypes are AgeVerifiable
protocol AgeVerifiable {
  func years(fromSeconds seconds: TimeInterval) -> TimeInterval
  func ageFrom(dateString string: BirthDate) throws -> TimeInterval
  func isValidChildAge(dateString string: BirthDate) throws -> Bool
  func isValidSeniorAge(dateString string: BirthDate) throws -> Bool
}

extension AgeVerifiable {
  
  // converts passed in timeInterval (seconds) to number of years
  func years(fromSeconds seconds: TimeInterval) -> TimeInterval {
    // 60 sec per min 60 min per hour 24 hour per day avg 365.2425 day per year
    let (secPerMin, minPerHour): (Double, Double) = (60,60)
    let (hoursPerDay, daysPerYear): (Double, Double) = (24, 365.2425)
    let numSecInYear = secPerMin * minPerHour * hoursPerDay * daysPerYear
    return seconds / numSecInYear
  }
  
  // calculates an age in years from a given date string in format "yyyy/mm/dd"
  func ageFrom(dateString string: BirthDate) throws -> TimeInterval {
    let today = Date()
    guard let birthdate = AccessPassGenerator.AccessPass.dateFormatter.date(from: string) else {
      throw AccessPassError.InvalidDateFormat(message: "Please enter date in format:\n\"yyyy/mm/dd\"")
    }
    let timeInterval = today.timeIntervalSince(birthdate)
    return years(fromSeconds: timeInterval)
  }
  
  func isValidChildAge(dateString string: BirthDate) throws -> Bool {
    do {
      let age = try ageFrom(dateString: string)
      print(age)
      guard age < maxChildAge else {
        throw AccessPassError.FailsChildAgeRequirement(message: "Child does not meet age requirements for a free child pass")
      }
      return age < maxChildAge
    }
  }
  
  func isValidSeniorAge(dateString string: BirthDate) throws -> Bool {
    do {
      let age = try ageFrom(dateString: string)
      guard age >= seniorAge else {
        throw AccessPassError.FailsSeniorAgeRequirement(message: "Guest does not meet age requirements for a Senior Pass.")
      }
      return age >= seniorAge
    }
  }
}
