//
//  ViewController.swift
//  AmusementparkPassGeneratorPart2
//
//  Created by Katherine Ebel on 11/10/16.
//  Copyright © 2016 Katherine Ebel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    let passGenerator = AccessPassGenerator.passGenerator
    let cardReader = AccessCardReader.cardReader
    let info = ContactInformation(firstName: "Kathy", lastName: "Ebel")
    let seasonPass = passGenerator.createPass(forEntrant: GuestType.seasonPass(info))
    print(seasonPass)
    print(cardReader.areaAccess(forPass: seasonPass))
    print(cardReader.rideAccess(forPass: seasonPass))
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

