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

// Currently only GuestTypes are AgeVerifiable
protocol AgeVerifiable {
  var dateFormatter: DateFormatter { get }
  func years(fromSeconds seconds: TimeInterval) -> TimeInterval
  func birthDate(dateString: String, meetsRequirement age: Double) throws -> Bool
}

extension AgeVerifiable {
  var dateFormatter: DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
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
  
  func birthDate(dateString: BirthDate, meetsRequirement age: Double) throws -> Bool {
    let today = Date()
    guard let birthdate = dateFormatter.date(from: dateString) else {
      throw AccessPassError.InvalidDateFormat(message: "Please enter date in format \"yyyy-mm-dd\"")
    }
    let timeInterval = today.timeIntervalSince(birthdate)
    let entrantAge = years(fromSeconds: timeInterval)
    guard entrantAge < age else {
      throw AccessPassError.FailsChildAgeRequirement(message: "Child does not meet age requirements for a free child pass\nPass converted to Classic Pass")
    }
    return years(fromSeconds: timeInterval) < age
  }
}
