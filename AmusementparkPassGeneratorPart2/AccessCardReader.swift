//
//  AccessCardReader.swift
//  AmusementParkPassGenerator
//
//  Created by Katherine Ebel on 11/5/16.
//  Copyright © 2016 Katherine Ebel. All rights reserved.
//

import AudioToolbox
struct AccessCardReader: CardReader {
  static let sharedCardReader = AccessCardReader()
  var (lastPassID, lastTimeStamp): (passID:PassID?, timeStamp: TimeInterval?)
  var minimumTimeWait: TimeInterval = 10
  var timeStamp: TimeInterval {
    return Date().timeIntervalSince1970
  }
  private init() {
    lastPassID = nil
  }
}

extension AccessCardReader {
  // returns a message of all accessable areas for pass
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
  
  // returns a message for all types of ride access
  func rideAccess(forPass pass: PassType) -> AccessMessage {
    var message = "Pass has access to: "
    let allRideAccess = pass.allRideAccess
    let skipsQueues = pass.skipsQueues
    message += allRideAccess ? "All Rides" : ""
    if allRideAccess && skipsQueues {
      message += " ,and skips lines for queues"
    } else {
      message = "This pass does not have any ride access"
    }
    return message
  }
  
  // returns a message for all associated discounts for pass
  func discountAccess(forPass pass: PassType) -> AccessMessage {
    let foodDiscount = pass.foodDiscount
    let merchandiseDiscount = pass.merchandiseDiscount
    if foodDiscount == 0 && merchandiseDiscount == 0 {
      return "This pass is not eligible for any discounts"
    } else {
      return "This pass gets a food discount of \(foodDiscount)%, and a merchandise discount of \(merchandiseDiscount)%"
    }
  }
  
  // MARK: Swipe Access
  // takes pass and an access area and returns true /plays sound if pass has access
  func swipeAccess(_ pass: PassType, hasAccessTo area: AccessArea) -> (hasAccess: Bool, message: AccessMessage) {
    let bdayMessage = birthdayMessage(forPass: pass)
    var message = "\(bdayMessage)\n"
    let success = pass.hasAccess(toArea: area)
    message += success ? "This pass has access to \(area.rawValue) areas" :
      "This pass doesn't have access to \(area.rawValue) areas"
    playSound(success)
    return (success, message)
  }
  
  // swipe a pass for individual types of discounts plays appropriate sound
  func swipeAccess(_ pass: PassType, discountFor type: DiscountType) -> (hasAccess: Bool, message: AccessMessage) {
    let bdayMessage = birthdayMessage(forPass: pass)
    var (discountType, discountAmount): (AccessMessage, AccessMessage)
    switch type {
    case .food(let foodDiscount): (discountType, discountAmount) =  ("Food", "\(foodDiscount)")
    case .merchandise(let merchandiseDiscount): (discountType, discountAmount) = ("Merchandise", "\(merchandiseDiscount)")
    }
    let success = discountAmount != "0"
    playSound(success)
    return (success, success ? "\(bdayMessage)\nThis pass has a \(discountAmount)% \(discountType.lowercased()) discount" : "\(bdayMessage)\nThis pass doesn't have a \(discountType.lowercased()) discount")
    
  }
  
  // swipe a pass for individual types of ride access -- plays appropriate sound
  mutating func swipeAccess(_ pass: PassType, hasRideAccess type: RideAccess) -> (hasAccess: Bool, message: AccessMessage) {
    do {
      let _ = try isValidSwipe(forID: pass.passID)
    } catch AccessPassError.DoubleSwipeError(message: let message) {
      return(false, message)
    } catch let error {
      return (false, "\(error)")
    }
    var (hasAccess, message): (Bool, AccessMessage)
    switch type {
    case .allRides(let success): (hasAccess, message) = (success, "to all rides")
    case .skipsQueues(let success): (hasAccess, message) = (success, "to skip lines for rides")
    }
    
    let bdayMessage = birthdayMessage(forPass: pass)
    playSound(hasAccess)
    (lastPassID, lastTimeStamp) = (pass.passID, timeStamp)
    // return a tuple with bool to determine success and message to display
    return (hasAccess, hasAccess ?
      "\(bdayMessage)\nThis pass has access \(message)" : "\(bdayMessage)\nThis pass doesn't have access \(message)")
  }
  
  // displays error message if id matches lastUsedId and also used < 10 seconds ago
  private func isValidSwipe(forID id: PassID) throws -> Bool {
    let currentTime = timeStamp
    if let lastUsedID = lastPassID, let lastStamp = lastTimeStamp {
      if id == lastUsedID  {
        guard currentTime - lastStamp > minimumTimeWait else {
          playSound(currentTime - lastStamp > minimumTimeWait)
          throw AccessPassError.DoubleSwipeError(message: "Swipe error. Check card ID. This card's id: \(id) was already swiped")
        }
        return true
      }
    }
    return true
  }
  
  // pass will be checked every time it is swiped *** only child, senior and vendor birthdays are known
  func alertBirthday(forPass pass: PassType) -> AccessMessage {
    guard pass.type is AgeVerifiable && pass.type is GuestType || pass.type is TemporaryType else {
      return ""
    }
    var isMatch = false
    if pass.type is GuestType {
      switch pass.type as! GuestType {
      case .classic, .VIP, .seasonPass: return ""
      case .freeChild(birthdate: let birthday), .senior(birthdate: let birthday, contactInfo: _):
        isMatch = isBirthday(forPass: pass, withDate: birthday)
      }
    }
    if pass.type is TemporaryType {
      switch pass.type as! TemporaryType {
      case .contractEmployee: return ""
      case .vendor(info: let visitorInformation, accessAreas: _):
        let birthday = visitorInformation.dateOfBirth
        isMatch = isBirthday(forPass: pass, withDate: birthday)
      }
    }
    return isMatch ? "Happy Birthday" : ""
  }
  
  // returns an empty string, happy birthday or includes name if it is known
  private func birthdayMessage(forPass pass: PassType) -> AccessMessage {
    var firstName = ""
    switch pass.type {
      // names are known for senior and vendors so personalize birthday greeting with their name
      case let kind where kind is TemporaryType:
        switch kind as! TemporaryType {
          case .vendor(info: let vendorInfo, accessAreas: _): firstName += vendorInfo.contactInfo.firstName
          default: break
        }
      case let kind where kind is GuestType:
        switch kind as! GuestType {
          case .senior(birthdate: _, contactInfo: let details): firstName += details.firstName
          default: break
        }
      default: break
    }
    var birthDayMessage = alertBirthday(forPass: pass)
    if !birthDayMessage.isEmpty {
      if !firstName.isEmpty {
        birthDayMessage += " \(firstName)!"
      } else {
        birthDayMessage += "!"
      }
      return birthDayMessage
    }
    return birthDayMessage
  }
  
  // MARK: Helper methods
  // this formats the entrants birthday and current days date in the same way, and
  // strips the year off of both and compares the remaining strings. If they are
  // equal, it is the entrant's birthday.
  // I currently only have birthdays attached to child passes.
  private func isBirthday(forPass pass: PassType, withDate date: BirthDate) -> Bool {
    let formatter = AccessPassGenerator.AccessPass.dateFormatter
    let todaysDate = formatter.string(from: Date()).replacingOccurrences(of: "-", with: "/")
    let compareIndex = date.index(date.endIndex, offsetBy: -5)
    if date.substring(to: compareIndex) == todaysDate.substring(to: compareIndex) {
      return true
    } else {
      return false
    }
  }
  
  // called for swipe features displays error message if sound can't be loaded
  func playSound(_ success: Bool) {
    let soundCue: AccessSoundCue = success ? .accessGranted : .accessDenied
    do {
      let soundID = try AccessSoundCue.sound(fromRawValue: soundCue.rawValue)
      AudioServicesPlaySystemSound(soundID)
    } catch AccessPassError.AccessSoundQueueError(message: let message) {
      print(message)
    } catch let error {
      print("\(error)")
    }
  }
}
