//
//  ViewController.swift
//  AmusementparkPassGeneratorPart2
//
//  Created by Katherine Ebel on 11/10/16.
//  Copyright © 2016 Katherine Ebel. All rights reserved.
//

import UIKit

// UITextfield delegate extension in TextFieldDelegate.swift
class CreatePassController: UIViewController {

  @IBOutlet weak var generatePassButton: UIButton!
  @IBOutlet weak var populateDataButton: UIButton!
  @IBOutlet weak var entrantTypeStackView: UIStackView!
  @IBOutlet weak var entrantSubTypeStackView: UIStackView!
  @IBOutlet weak var mainStackViewTopConstraint: NSLayoutConstraint!
  @IBOutlet var informationStackViews: [UIStackView]!
  
  let passGenerator = AccessPassGenerator.passGenerator
  var selectedEntrantType: EntrantType = .Guest
  var selectedSubType: SubType = GuestType.classic.subType
  var activeTextFields: [InformationField : UITextField] = [:]
  var activeTextField: UITextField = UITextField()
  let dummyData = DummyData()
  var entrantPass: PassType? = nil
  
    
  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(CreatePassController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(CreatePassController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    setSubTypes(forType: .Guest)
    disableTextFields()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: IBAction Methods
  @IBAction func selectEntrantType(_ sender: UIButton) {
    setColorsForButtons(inStack: entrantTypeStackView, selectedButton: sender)
    disableTextFields()
    if let entrantType = EntrantType(rawValue: sender.currentTitle!) {
      selectedEntrantType = entrantType
      setSubTypes(forType: entrantType)
    }
  }
  
  // creates pass and triggers segue if pass creation successful, otherwise
  // alerts user.
  @IBAction func generatePassButtonPressed() {
    if let infoDict = createInfoDict(), let guest = guestWithInfo(infoDict: infoDict) {
      let result = passGenerator.createPass(forEntrant: guest)
      if let guestPass = result.entrantPass {
        entrantPass = guestPass
        performSegue(withIdentifier: "testPass", sender: self)
      } else {
        let alert = UIAlertController(title: "Sorry, something went wrong!", message: result.message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Try again?", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
      }
    }
  }
  
  // Fills required fields with valid data needed to create a pass
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
      case .Employee, .Manager, .Contractor: info = dummyData.contactInformation
      case .Vendor: info = dummyData.vendorInfo
    }
    UIView.animate(withDuration: 0.8) {
      // set the text in the activeTextFields
      _ = info.map { (field, text) in self.activeTextFields[field]?.text = text }
    }
  }
  
  // allows user to tap outside of the textfield to dismiss keyboard
  @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
    activeTextField.resignFirstResponder()
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
      let button = UIButton(type: .system)
      let buttonColor = UIColor(red: 135/255.0, green: 126/255.0, blue: 145/255.0, alpha: 1.0)
      button.setTitle(title, for: .normal)
      button.setTitleColor(buttonColor, for: .normal)
      button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: UIFontWeightBold)
      entrantSubTypeStackView.addArrangedSubview(button)
      button.addTarget(self, action: #selector(CreatePassController.enableFieldsForSubType(_:)), for: .touchUpInside)
    }
  }
  
  // set a white color on the currently active entrantType/subtype button and darken the others
  func setColorsForButtons(inStack stackview: UIStackView, selectedButton: UIButton) {
    _ = stackview.arrangedSubviews.map { view in
      if let button = view as? UIButton {
        let inactiveColor = UIColor(red: 189/255.0, green: 170/255.0, blue: 208/255.0, alpha: 1.0)
        // if button is active set to white color, else set to inactive color
        button.setTitleColor(button == selectedButton ? .white : inactiveColor, for: .normal)
      }
    }
  }
  // get text out of active Textfields and converts it to a dictionary with info fields and String values
  func createInfoDict() -> [InformationField: String]? {
     let passInfo = activeTextFields.reduce([InformationField: String](), {(result, nextValue) in
      var dict = result
      dict.updateValue(nextValue.value.text!, forKey: nextValue.key)
      return dict
    })
    if hasEmptyValues(inDictionary: passInfo) {
      alertEmptyValues()
      return nil
    } else {
      return passInfo
    }
  }
  
  // prevents any empty values from being submitted
  func hasEmptyValues(inDictionary dictionary: [InformationField: String]) -> Bool {
    for (_, value) in dictionary {
      if value.isEmpty {
        return true
      }
    }
    return false
  }
  
  // present an alert if any of the values entered were empty
  func alertEmptyValues() {
    let alert = UIAlertController(title: "Invalid input", message: "Fields cannot be empty", preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
  // allows dictionary to be passed in and returns the right ParkEntrant type
  func guestWithInfo(infoDict dict: [InformationField: String]) -> ParkEntrant? {
    var parkGuest: ParkEntrant? = nil
    if let passInfo = createInfoDict() {
      switch selectedEntrantType {
      case .Guest:
        if let guest = GuestType.guest(forSubType: selectedSubType, withInfo: passInfo) {
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
    }
    if let parkGuest = parkGuest {
      return parkGuest
    } else {
      return nil
    }
  }
  
  // MARK: Helpers to update textFields -- enable/disable/default values
  
  func enableFieldsForSubType(_ sender: UIButton) {
    // when subtype button is clicked, first highlight the selected button
    UIView.animate(withDuration: 0.5) {
      self.setColorsForButtons(inStack: self.entrantSubTypeStackView, selectedButton: sender)
    }
    disableTextFields() // if there are any textfields already active, clear the text and disable them
    // update the property for selected subtype
    selectedSubType = sender.currentTitle!
    let tags: [Tag]
    // get the required fields depending on the selected entrant and subtype
    switch selectedEntrantType {
    case .Guest:
      tags = GuestType.getRequiredFields(fromTitle: selectedSubType).map { $0.rawValue }
    case .Employee, .Manager:
      tags = HourlyEmployeeType.getRequiredFields().map { $0.rawValue }
    case .Contractor, .Vendor:
      tags = TemporaryType.getRequiredFields(fromTitle: selectedSubType).map { $0.rawValue }
    }
    // animate the texfields into not disabled state
    UIView.animate(withDuration: 0.5) { self.enableTextFields(withTags: tags) }
  }
  
  func enableTextFields(withTags tags: [Tag]) {
    // find all of the required textFields
    let views = informationStackViews.flatMap { $0.arrangedSubviews }
    // all the textFields have an associated tag to more easily identify it ** rawValue for InformationField enum
    let textFields = (views.filter { tags.contains($0.tag) }).map { $0 as! UITextField }
    // add required fields to activeTextFields dict and enable them
    let _ = textFields.enumerated().map { (index, textField) in
      let tag = InformationField(rawValue: tags[index])!
      activeTextFields.updateValue(textField, forKey: tag) // associates a information field with a textfield
      textField.text = ""
      textField.isUserInteractionEnabled = true
      textField.backgroundColor = .white
    }
    fillDefaultValuesForFields()
  }
  
  // fills in default values for contractor and vendors since they are required to have certain project and
  // vendor company names
  func fillDefaultValuesForFields() {
    // return early if no default values needed
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
        // get current date to display in the date of visit field since it will most likely default to current day
        let todaysDate = AccessPassGenerator.AccessPass.dateFormatter.string(from: Date())
        value.text = todaysDate
      }
      if key == .projectNumber || key == .companyName {
        value.text = selectedSubType
      }
    }
  }
  
  // clears activeTextFields property, clears text and disables all textfields
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
  
  // MARK: Manage Keyboard
  func keyboardWillShow(notification: NSNotification) {
    // in portrait, the only textfields that are covered are the ones in the bottom row, so move keyboard for those
    let textFieldsToMove = [activeTextFields[.streetAddress], activeTextFields[.city], activeTextFields[.state], activeTextFields[.zipCode]]
    if let userInfoDict = notification.userInfo,
      let keyboardFrameValue = userInfoDict[UIKeyboardFrameEndUserInfoKey] as? NSValue {
      let keyboardFrame = keyboardFrameValue.cgRectValue
      if textFieldsToMove.contains(where: { (textField) -> Bool in textField == activeTextField }) {
      UIView.animate(withDuration: 0.8) {
        self.mainStackViewTopConstraint.constant = 100 - keyboardFrame.size.height
        self.view.layoutIfNeeded()
      }
        
      }
    }
  }
  
  func keyboardWillHide(notification: NSNotification) {
    UIView.animate(withDuration: 0.8) {
      self.mainStackViewTopConstraint.constant = 100.0
      self.view.layoutIfNeeded()
    }
  }
  
  // MARK: Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "testPass" {
      let testPassController = segue.destination as! TestPassController
      if let entrantPass = self.entrantPass {
        testPassController.entrantPass = entrantPass
      }
    }
  }
}

