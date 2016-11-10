//
//  TemporaryType.swift
//  AmusementparkPassGeneratorPart2
//
//  Created by Katherine Ebel on 11/10/16.
//  Copyright © 2016 Katherine Ebel. All rights reserved.
//

import Foundation

enum TemporaryType: ParkEntrant {
  case vendor(birthdate: BirthDate, dateOfVisit: String)
  case contractEmployee(projectNumber: Int, accessAreas: [AccessArea])
}

extension TemporaryType {
  var accessAreas: [AccessArea] {
    get {
      return self.accessAreas
    }
    set {
      accessAreas = newValue
    }
  }
}
