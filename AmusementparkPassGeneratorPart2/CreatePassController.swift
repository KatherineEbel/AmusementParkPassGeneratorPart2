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
    let cardReader = AccessCardReader.sharedCardReader
    let info = ContactInformation(firstName: "Kathy", lastName: "Ebel")
    let vendorVisit = VendorVisitInformation(companyName: "Acme", dateOfVisit: "2016-11-12", dateOfBirth: "11-12-1978", contactInfo: info)
    let vendorPass = passGenerator.createPass(forEntrant: TemporaryType.vendor(info: vendorVisit, accessAreas: []))
    print(cardReader.areaAccess(forPass: vendorPass))
    print(cardReader.rideAccess(forPass: vendorPass))
    print(cardReader.swipeAccess(vendorPass, hasAccessTo: .kitchen))
//    let infoDict = ["firstName": "Kathy", "lastName": "Ebel", "streetAddress": "1 Wonder Way", "city": "Somewhere Out There", "state": "CA", "zipCode": "90210"]
//    let contractEmpInfo = ContractEmployeeInformation(projectID: 1001, withInfo: infoDict)
//    let tempEmployee = TemporaryType.contractEmployee(info: contractEmpInfo!, accessAreas: [])
//    let contractEmpPass = passGenerator.createPass(forEntrant: tempEmployee)
//    print(cardReader.areaAccess(forPass: contractEmpPass))
//    print(cardReader.discountAccess(forPass: contractEmpPass))
//    print(cardReader.rideAccess(forPass: contractEmpPass))
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

