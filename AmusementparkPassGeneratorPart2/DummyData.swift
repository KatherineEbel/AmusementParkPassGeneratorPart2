//
//  DummyData.swift
//  AmusementparkPassGeneratorPart2
//
//  Created by Katherine Ebel on 11/14/16.
//  Copyright © 2016 Katherine Ebel. All rights reserved.
//

import Foundation

struct DummyData {
  let childInfo: [InformationField: String] = [.dateOfBirth: "11/14/2013"]
  let seniorInfo: [InformationField: String] = [
    .dateOfBirth: "11/14/1945", .firstName: "John", .lastName: "Roberts"
  ]
  let vendorInfo: [InformationField: String] = [
    .dateOfBirth: "11/14/1985", .firstName: "Rick", .lastName: "Schmidt"
  ]
  
  let contactInformation: [InformationField: String] = [
    .firstName: "Amanda", .lastName: "Johnson", .streetAddress: "130 Wonder Way",
    .city: "Somewhere Out There", .state: "CA", .zipCode: "90210"
  ]
  let nameInformation: [InformationField: String] = [
    .firstName: "Matthew", .lastName: "Sanders"
  ]
}
