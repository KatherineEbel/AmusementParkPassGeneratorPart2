//
//  AccessSoundCue.swift
//  AmusementparkPassGeneratorPart2
//
//  Created by Katherine Ebel on 11/12/16.
//  Copyright © 2016 Katherine Ebel. All rights reserved.
//

import Foundation
import Foundation
import AudioToolbox

// used by the AccessCardReader to play sounds when accessCards are swiped
enum AccessSoundCue: String {
  case accessDenied = "AccessDenied"
  case accessGranted = "AccessGranted"
}

extension AccessSoundCue {
  static func sound(fromRawValue value: String) throws -> SystemSoundID {
    var soundId: SystemSoundID = 0
    guard let pathToSoundFile = Bundle.main.path(forResource: value, ofType: "wav") else {
      throw AccessPassError.AccessSoundQueueError(message: "Could not load sound for resource \(value)")
    }
    let url = URL(fileURLWithPath: pathToSoundFile)
    AudioServicesCreateSystemSoundID(url as CFURL, &soundId)
    return soundId
  }
}
