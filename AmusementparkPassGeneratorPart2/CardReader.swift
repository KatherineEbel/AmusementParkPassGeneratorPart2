//
//  CardReader.swift
//  AmusementParkPassGenerator
//
//  Created by Katherine Ebel on 11/5/16.
//  Copyright © 2016 Katherine Ebel. All rights reserved.
//

typealias AccessMessage = String
protocol CardReader {
  func areaAccess(forPass pass: PassType) -> AccessMessage
  func rideAccess(forPass pass: PassType) -> AccessMessage
  func discountAccess(forPass pass: PassType) -> AccessMessage
  func alertBirthday(forPass pass: PassType) -> AccessMessage
  func swipeAccess(_ pass: PassType, hasAccessTo area: AccessArea) -> Bool
  func playSound(_ success: Bool)
}
