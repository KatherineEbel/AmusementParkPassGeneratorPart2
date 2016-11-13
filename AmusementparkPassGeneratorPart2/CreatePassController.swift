//
//  ViewController.swift
//  AmusementparkPassGeneratorPart2
//
//  Created by Katherine Ebel on 11/10/16.
//  Copyright © 2016 Katherine Ebel. All rights reserved.
//

import UIKit

class CreatePassController: UIViewController {

  @IBOutlet weak var generatePassButton: UIButton!
  @IBOutlet weak var populateDataButton: UIButton!
  @IBOutlet weak var entrantTypeStackView: UIStackView!
  @IBOutlet weak var entrantSubTypeStackView: UIStackView!
  
  let passGenerator = AccessPassGenerator.passGenerator
  let cardReader = AccessCardReader.sharedCardReader
  @IBAction func selectEntrantType(_ sender: UIButton) {
    if let entrantType = EntrantType(rawValue: sender.currentTitle!) {
      setSubTypes(forType: entrantType)
    }
  }
  
  func setSubTypes(forType type: EntrantType) {
    let _ = entrantSubTypeStackView.arrangedSubviews.map {
      entrantSubTypeStackView.removeArrangedSubview($0)
      $0.removeFromSuperview()
    }
    var titles: [String] = []
    switch type {
      case .Guest: titles = GuestType.allTypes
      case .Employee: titles = HourlyEmployeeType.allTypes
      case .Manager: titles = ManagerType.allTypes
      case .Vendor: titles = passGenerator.allowedVendors.map { $0.companyName }
      case .Contractor: titles = passGenerator.openProjects.map { String($0.identificationNumber) }
    }
    for title in titles {
      let button = EntrantTypeButton()
      button.setTitle(title, for: .normal)
      entrantSubTypeStackView.addArrangedSubview(button)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setSubTypes(forType: .Guest)
//    let info = ContactInformation(firstName: "Kathy", lastName: "Ebel")
//    let vendorVisit = VendorVisitInformation(companyName: "Acme", dateOfVisit: "2016-11-12", dateOfBirth: "11-12-1978", contactInfo: info)
//    let vendorPass = passGenerator.createPass(forEntrant: TemporaryType.vendor(info: vendorVisit, accessAreas: []))
//    print(cardReader.areaAccess(forPass: vendorPass))
//    print(cardReader.rideAccess(forPass: vendorPass))
//    print(cardReader.swipeAccess(vendorPass, hasAccessTo: .kitchen))
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

