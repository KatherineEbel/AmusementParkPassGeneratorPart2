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
}
