//
//  ContractEmployeeInformation.swift
//  AmusementparkPassGeneratorPart2
//
//  Created by Katherine Ebel on 11/11/16.
//  Copyright © 2016 Katherine Ebel. All rights reserved.
//

import Foundation

class ContractEmployeeInformation: ContactInformation {
  let projectID: Int
  
  init?(projectID: Int, withInfo info: [InformationField: String]) {
    self.projectID = projectID
    super.init(withDictionary: info)
  }
}
