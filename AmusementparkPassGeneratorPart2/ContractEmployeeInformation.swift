//
//  ContractEmployeeInformation.swift
//  AmusementparkPassGeneratorPart2
//
//  Created by Katherine Ebel on 11/11/16.
//  Copyright © 2016 Katherine Ebel. All rights reserved.
//

import Foundation

class ContractEmployeeInformation: ContactInformation {
  let projectNumber: String
  
  init?(projectNumber: String, withInfo info: [InformationField: String]) {
    self.projectNumber = projectNumber
    super.init(withDictionary: info)
  }
}
