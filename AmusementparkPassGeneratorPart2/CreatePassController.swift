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
  @IBOutlet weak var mainStackViewTopConstraint: NSLayoutConstraint!

  @IBOutlet var informationStackViews: [UIStackView]!

  @IBOutlet weak var companyNameStackView: UIStackView!
  
  let passGenerator = AccessPassGenerator.passGenerator
  let cardReader = AccessCardReader.sharedCardReader
  var selectedEntrantType: EntrantType = .Guest
  var selectedSubType: String = "Classic"
  var activeTextFields: [InformationField : UITextField] = [:]
  var activeTextField: UITextField = UITextField()
  let dummyData = DummyData()
  
    
  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(CreatePassController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(CreatePassController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    setSubTypes(forType: .Guest)
    disableTextFields()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func selectEntrantType(_ sender: UIButton) {
    disableTextFields()
    if let entrantType = EntrantType(rawValue: sender.currentTitle!) {
      selectedEntrantType = entrantType
      setSubTypes(forType: entrantType)
    }
  }
  
  @IBAction func generatePassButtonPressed() {
    if let guest = guestWithInfo(infoDict: createInfoDict()) {
      let pass = passGenerator.createPass(forEntrant: guest)
      print(cardReader.areaAccess(forPass: pass))
    }
  }
  
  @IBAction func populateDataButtonPressed() {
    guard !activeTextFields.isEmpty else {
      return
    }
    var info: [InformationField: String] = [:]
    switch selectedEntrantType {
      case .Guest:
        switch selectedSubType {
          case "Free Child": info = dummyData.childInfo
          case "Senior": info = dummyData.seniorInfo
          case "Season Pass": info = dummyData.contactInformation
          default: break
        }
      case .Employee, .Manager: info = dummyData.contactInformation
      case .Contractor: info = dummyData.nameInformation
      case .Vendor: info = dummyData.vendorInfo
    }
    let _ = info.map { (key, value) in activeTextFields[key]?.text = value }
  }
  
  // MARK: Create SubType Buttons
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
    addSubTypeButtons(withTitles: titles)
  }
  
  // dynamically adds needed buttons depending on the given titles -- determined by setSubtypes function
  func addSubTypeButtons(withTitles titles: [String]) {
    for title in titles {
      let button = EntrantTypeButton()
      button.setTitle(title, for: .normal)
      entrantSubTypeStackView.addArrangedSubview(button)
      button.addTarget(self, action: #selector(CreatePassController.enableFieldsForSubType(_:)), for: .touchUpInside)
    }
  }
  
  
  // get text out of active Textfields
  func createInfoDict() -> [InformationField: String] {
    var infoDict: [InformationField: String] = [:]
    let _ = activeTextFields.map { (key, value) in
      infoDict.updateValue(value.text!, forKey: key)
    }
    return infoDict
  }
  
  // allows dictionary to be passed in and returns the right ParkEntrant type
  func guestWithInfo(infoDict dict: [InformationField: String]) -> ParkEntrant? {
    var parkGuest: ParkEntrant? = nil
    let passInfo = createInfoDict()
    switch selectedEntrantType {
    case .Guest:
      if let guest = GuestType.guestType(forType: selectedSubType, withInfo: passInfo) {
        parkGuest = guest
      }
    case .Employee:
      if let employee = HourlyEmployeeType.employee(forType: selectedSubType, withInfo: passInfo) {
        parkGuest = employee
      }
    case .Manager:
      if let manager = ManagerType.managerType(forSubType: selectedSubType, withInfo: passInfo) {
        parkGuest = manager
      }
    case .Contractor:
      let accessAreas = (passGenerator.openProjects.filter { $0.identificationNumber == Int(selectedSubType) }.first!).accessAreas
      if let tempType = TemporaryType.temporaryType(forEntrantType: selectedEntrantType, withInfo: passInfo, accessAreas: accessAreas) {
        parkGuest = tempType
      }
    case .Vendor:
      let accessAreas = (passGenerator.allowedVendors.filter { $0.companyName == selectedSubType }).first!.accessAreas
      if let tempType = TemporaryType.temporaryType(forEntrantType: selectedEntrantType, withInfo: passInfo, accessAreas: accessAreas) {
        parkGuest = tempType
      }
    }
    if let parkGuest = parkGuest {
      return parkGuest
    } else {
      return nil
    }
  }
  
  // MARK: Helpers to update textFields -- enable/disable/default values
  
  func enableFieldsForSubType(_ sender: UIButton) {
    disableTextFields()
    selectedSubType = sender.currentTitle!
    let tags: [Tag]
    switch selectedEntrantType {
    case .Guest:
      tags = GuestType.getRequiredFields(fromTitle: selectedSubType).map { $0.rawValue }
      enableTextFields(withTags: tags)
    case .Employee, .Manager:
      tags = HourlyEmployeeType.getRequiredFields().map { $0.rawValue }
      enableTextFields(withTags: tags)
    case .Contractor, .Vendor:
      tags = TemporaryType.getRequiredFields(fromTitle: selectedSubType).map { $0.rawValue }
      enableTextFields(withTags: tags)
    }
  }
  
  func enableTextFields(withTags tags: [Tag]) {
    // find all of the required textFields
    let views = informationStackViews.flatMap { $0.arrangedSubviews }
    let textFields = (views.filter { tags.contains($0.tag) }).map { $0 as! UITextField }
    // add required fields to activeTextFields dict and enable them
    let _ = textFields.enumerated().map { (index, textField) in
      let tag = InformationField(rawValue: tags[index])!
      activeTextFields.updateValue(textField, forKey: tag)
      textField.text = ""
      textField.isUserInteractionEnabled = true
      textField.backgroundColor = .white
    }
    fillDefaultValuesForFields()
  }
  
  func fillDefaultValuesForFields() {
    guard selectedEntrantType == .Contractor || selectedEntrantType == .Vendor else {
      return
    }
    let _ = activeTextFields.filter { (key, value) in
      if key == .projectNumber || key == .companyName || key == .dateOfVisit {
        return true
      } else {
        return false
      }
    }.map { (key, value) in
      if key == .dateOfVisit {
        let todaysDate = AccessPassGenerator.AccessPass.dateFormatter.string(from: Date())
        print(todaysDate)
        value.text = todaysDate
      }
      if key == .projectNumber || key == .companyName {
        value.text = selectedSubType
      }
    }
  }
  
  func disableTextFields() {
    activeTextFields = [:]
    let views = informationStackViews.flatMap { $0.arrangedSubviews }
    let textFields = (views.filter { $0.isKind(of: UITextField.self) }) as! [UITextField]
    let _ = textFields.map {
      $0.text = ""
      $0.isUserInteractionEnabled = false
      $0.backgroundColor = UIColor(red: 219/255.0, green: 214/255.0, blue: 233/255.0, alpha: 0.5)
    }
  }
  
  
  func keyboardWillShow(notification: NSNotification) {
    let shouldMove = activeTextField == activeTextFields[.city] || activeTextField == activeTextFields[.state] || activeTextField == activeTextFields[.zipCode]
    if shouldMove {
      UIView.animate(withDuration: 0.8) {
        self.mainStackViewTopConstraint.constant = 0.0
        self.view.layoutIfNeeded()
      }
    }
  }
  
  func keyboardWillHide(notification: NSNotification) {
    print("Keyboard will hide")
    UIView.animate(withDuration: 0.8) {
      print("Animating")
      self.mainStackViewTopConstraint.constant = 100.0
      self.view.layoutIfNeeded()
    }
  }
}

