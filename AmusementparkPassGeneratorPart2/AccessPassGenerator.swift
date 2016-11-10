//
//  AccessPassGenerator.swift
//  AmusementParkPassGenerator
//
//  Created by Katherine Ebel on 11/4/16.
//  Copyright © 2016 Katherine Ebel. All rights reserved.
//

import Foundation

final class AccessPassGenerator {
  // only way to create a access pass is the singleton passGenerator
  static let passGenerator = AccessPassGenerator()
  private let openProjects = [
    Project(identificationNumber: 1001, accessAreas: [.amusement, .rideControl]),
    Project(identificationNumber: 1002, accessAreas: [.amusement, .rideControl, .maintenance]),
    Project(identificationNumber: 1003, accessAreas: [.amusement, .rideControl, .kitchen, .maintenance, .office]),
    Project(identificationNumber: 2001, accessAreas: [.office]),
    Project(identificationNumber: 2002, accessAreas: [.kitchen, .maintenance,])
  ]
  private init() { }
  
  // added AccessPass struct to Pass Generator, so initializer for Access Pass can only
  // be called by generator
  struct AccessPass: PassType, AgeVerifiable {
    let type: ParkEntrant
    let maxChildAge: Double = 5
    fileprivate init(type: ParkEntrant) {
      self.type = type
    }
  }
  
  // the only public access point to create passes
  public func createPass(forEntrant entrant: ParkEntrant) -> AccessPass {
    if entrant is AgeVerifiable {
      return pass(forVerifiedEntrant: entrant as! AgeVerifiable) // force cast since has to be AgeVerifiable to get in this block
    }
    if entrant is HourlyEmployeeType {
      return AccessPass(type: entrant as! HourlyEmployeeType)
    }
    if entrant is ManagerType {
      return AccessPass(type: entrant as! ManagerType)
    }
    if entrant is TemporaryType {
      do {
        return try pass(forTempEntrant: entrant as! TemporaryType)
      } catch AccessPassError.InvalidProjectNumber(message: let message) {
          print(message)
      } catch let error {
        print(error)
      }
    }
    // should never get to this final case
    return AccessPass(type: GuestType.classic)
  }
  
  
  // the only pass that needs to be verified is the free child pass -- since no UI currently present
  // default to displaying message and create classic pass for unverified/ or incorrectly formatted dates
  private func pass(forVerifiedEntrant entrant: AgeVerifiable) -> AccessPass {
    let type = entrant as! GuestType
    switch type {
    case .classic: return AccessPass(type: GuestType.classic)
    case .VIP: return AccessPass(type: GuestType.VIP)
    case .freeChild(birthdate: let birthDate):
      let pass = AccessPass(type: GuestType.freeChild(birthdate: birthDate))
        if pass.isVerified {
           return pass
        } else {
          return AccessPass(type: GuestType.classic)
        }
    case .senior(birthdate: let date, contactInfo: let info):
      let pass = AccessPass(type: GuestType.senior(birthdate: date, contactInfo: info))
        if pass.isVerified {
           return pass
        } else {
          return AccessPass(type: GuestType.classic)
        }
    case .seasonPass(let contactInfo):
      return AccessPass(type: GuestType.seasonPass(contactInfo))
    }
  }
  
  private func pass(forTempEntrant entrant: TemporaryType) throws -> AccessPass {
    switch entrant {
      case .contractEmployee(projectNumber: let projectNumber):
        if let project = (openProjects.filter { $0.identificationNumber == projectNumber }).first {
          return AccessPass(type: TemporaryType.contractEmployee(projectNumber: project.identificationNumber, accessAreas: project.accessAreas))
        } else {
          throw AccessPassError.InvalidProjectNumber(message: "No project found with that access number, please double check entry.")
        }
        
      case .vendor(birthdate: let date, dateOfVisit: let visitDate):
        return createPass(forEntrant: TemporaryType.vendor(birthdate: date, dateOfVisit: visitDate))
    }
  }
}
