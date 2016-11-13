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

  @IBOutlet var informationStackViews: [UIStackView]!

  @IBOutlet weak var companyNameStackView: UIStackView!
  
  let passGenerator = AccessPassGenerator.passGenerator
  let cardReader = AccessCardReader.sharedCardReader
  var selectedEntrantType: EntrantType = .Guest
  var selectedSubType = GuestType.classic
  
    
  override func viewDidLoad() {
    super.viewDidLoad()
    setSubTypes(forType: .Guest)
    disableTextFields()
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
  
  @IBAction func selectEntrantType(_ sender: UIButton) {
    if let entrantType = EntrantType(rawValue: sender.currentTitle!) {
      selectedEntrantType = entrantType
      setSubTypes(forType: entrantType)
    }
  }
  
  func enableFieldsForSubType(_ sender: UIButton) {
    let title = sender.currentTitle!
    let fields: [Tag]
    switch selectedEntrantType {
    case .Guest:
      fields = GuestType.getRequiredFields(fromTitle: title).map { $0.rawValue }
      enableTextFields(withTags: fields)
      print(fields)
    default:
      break
    }
  }
  
  func enableTextFields(withTags tags: [Tag]) {
    let views = informationStackViews.flatMap { $0.arrangedSubviews }
    var textFields: [UITextField] = []
    for tag in tags {
      let fields = views.filter { $0 == $0.viewWithTag(tag) }
      textFields.append(fields[0] as! UITextField)
    }
    let _ = textFields.map {
      $0.isUserInteractionEnabled = true
      $0.backgroundColor = .white
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
      button.addTarget(self, action: #selector(CreatePassController.enableFieldsForSubType(_:)), for: .touchUpInside)
    }
  }
  
  func disableTextFields() {
    let views = informationStackViews.flatMap { $0.arrangedSubviews }
    let textFields = views.filter {
      $0.isKind(of: UITextField.self)
    }
    let _ = textFields.map {
      $0.isUserInteractionEnabled = false
      $0.backgroundColor = UIColor(red: 219/255.0, green: 214/255.0, blue: 233/255.0, alpha: 0.5)
      
    }
  }
  
  

}

