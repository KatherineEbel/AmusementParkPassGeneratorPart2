//
//  AccessPassGenerator.swift
//  AmusementParkPassGenerator
//
//  Created by Katherine Ebel on 11/4/16.
//  Copyright © 2016 Katherine Ebel. All rights reserved.
//

import Foundation

typealias PassID = Int

final class AccessPassGenerator {
  // only way to create a access pass is the singleton passGenerator
  static let passGenerator = AccessPassGenerator()
  let openProjects = [
    Project(projectNumber: "1001", accessAreas: [.amusement, .rideControl]),
    Project(projectNumber: "1002", accessAreas: [.amusement, .rideControl, .maintenance]),
    Project(projectNumber: "1003", accessAreas: [.amusement, .rideControl, .kitchen, .maintenance, .office]),
    Project(projectNumber: "2001", accessAreas: [.office]),
    Project(projectNumber: "2002", accessAreas: [.kitchen, .maintenance,])
  ]
  let allowedVendors = [
    Vendor(companyName: "Acme", accessAreas: [.kitchen]),
    Vendor(companyName: "Orkin", accessAreas: [.amusement, .rideControl, .kitchen]),
    Vendor(companyName: "Fedex", accessAreas: [.maintenance, .office]),
    Vendor(companyName: "NW Electrical", accessAreas: [.amusement, .rideControl, .kitchen, .maintenance, .office]),
  ]
  private init() { }
  
  // added AccessPass struct to Pass Generator, so initializer for Access Pass can only
  // be called by generator
  struct AccessPass: PassType, AgeVerifiable {
    static var currentPassID: PassID = 1
    let type: ParkEntrant
    let maxChildAge: Double = 5
    let passID: PassID = AccessPass.currentPassID
    fileprivate init(type: ParkEntrant) {
      self.type = type
      AccessPass.currentPassID += 1
    }
  }
  
  // the only public access point to create passes -- returns an optional pass and a message with success result
  public func createPass(forEntrant entrant: ParkEntrant) -> (entrantPass: AccessPass?, message: AccessMessage) {
    if entrant is GuestType {
      if let result = pass(forVerifiedEntrant: entrant as! GuestType) {
        return (result.pass, result.message)
      }
    }
    if entrant is HourlyEmployeeType {
      return (AccessPass(type: entrant as! HourlyEmployeeType), "")
    }
    if entrant is ManagerType {
      return (AccessPass(type: entrant as! ManagerType), "")
    }
    if entrant is TemporaryType {
      do {
        let tempPass = try pass(forTempEntrant: entrant as! TemporaryType)
        return (tempPass, "Success")
      } catch AccessPassError.InvalidProjectNumber(message: let message) {
        return (nil, message)
        
      } catch AccessPassError.InvalidVendor(message: let message) {
        return (nil, message)
      } catch let error {
        return (nil, "\(error)")
      }
    }
    // should never get to this point
    return (nil, "Unable to create pass for give entries")
  }
  
  
  // the only pass that needs to be verified is the free child pass -- since no UI currently present
  // default to displaying message and create classic pass for unverified/ or incorrectly formatted dates
  private func pass(forVerifiedEntrant entrant: GuestType) -> (pass: AccessPass?, message: AccessMessage)? {
    switch entrant {
    case .classic: return (AccessPass(type: GuestType.classic), "Success")
    case .VIP: return (AccessPass(type: GuestType.VIP), "Success")
    case .freeChild(birthdate: let birthDate):
      let pass = AccessPass(type: GuestType.freeChild(birthdate: birthDate))
        if pass.isVerified.success {
           return (pass, "Success")
        } else {
          return (nil, pass.isVerified.message!)
        }
    case .senior(birthdate: let date, contactInfo: let info):
      let pass = AccessPass(type: GuestType.senior(birthdate: date, contactInfo: info))
        if pass.isVerified.success {
           return (pass, "Success")
        } else {
          return (nil, pass.isVerified.message!)
        }
    case .seasonPass(let contactInfo):
      return (AccessPass(type: GuestType.seasonPass(contactInfo: contactInfo)), "Success")
    }
  }
  
  private func pass(forTempEntrant entrant: TemporaryType) throws -> AccessPass {
    switch entrant {
      // don't pass in access areas for temp types because the park (and therefore pass generator) tracks the open projects
      // and allowed vendors, and knows what areas they were allowed entry to.
      case .contractEmployee(contactInfo: let info, accessAreas: _):
        let projectNumber = info.projectNumber
        if let project = (openProjects.filter { $0.projectNumber == projectNumber }).first { // try to find the project id that the contractEmployee has
          return AccessPass(type: TemporaryType.contractEmployee(contactInfo: info, accessAreas: project.accessAreas))
        } else {
          // If park does not know about the project number then refuse to create a pass
          throw AccessPassError.InvalidProjectNumber(message: "No project found with that access number, please double check entry.")
        }
    case .vendor(info: let vendorInfo):
      // if vendor name is not in allowed vendors don't create pass
      if let vendor = (allowedVendors.filter { $0.companyName == vendorInfo.info.companyName }).first {
        return AccessPass(type: TemporaryType.vendor(info: vendorInfo.info, accessAreas: vendor.accessAreas))
      } else {
        throw AccessPassError.InvalidVendor(message: "This vendor is not listed in the parks allowed Vendors")
      }
    }
  }
}
