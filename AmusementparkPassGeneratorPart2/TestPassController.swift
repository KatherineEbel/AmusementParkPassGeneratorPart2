//
//  TestPassController.swift
//  AmusementparkPassGeneratorPart2
//
//  Created by Katherine Ebel on 11/15/16.
//  Copyright © 2016 Katherine Ebel. All rights reserved.
//

import UIKit

class TestPassController: UIViewController {
  
  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var passTypeLabel: UILabel!
  @IBOutlet weak var rideAccessLabel: UILabel!
  @IBOutlet weak var foodDiscountLabel: UILabel!
  @IBOutlet weak var merchandiseDiscountLabel: UILabel!
  
  var entrantPass: PassType! = nil
  var cardReader = AccessCardReader.sharedCardReader
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupPassLabels()
  }
  
  override func viewWillLayoutSubviews() {
    textView.textContainerInset = UIEdgeInsets(top: 50, left: 30, bottom: 30, right: 30)
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  func setupPassLabels() {
    // Default value in case guest name not known
    var (firstName, lastName): (String, String) = ("Park", "Guest")
    if let contactInfo = entrantPass.contactInfo {
      (firstName, lastName) = (contactInfo.firstName, contactInfo.lastName)
    }
    nameLabel.text = "\(firstName.capitalized) \(lastName.capitalized)"
    passTypeLabel.text = "\(entrantPass.type.subType)" + " Pass"
    let (unlimitedRides, skipsLines) = (entrantPass.allRideAccess, entrantPass.skipsQueues)
    var rideAccess = unlimitedRides ? "Unlimited Rides" : "No Ride Access"
    rideAccess += skipsLines ? " & Skips Queues" : ""
    rideAccessLabel.text = rideAccess
    
    foodDiscountLabel.text = "\(entrantPass.foodDiscount)% food discount"
    merchandiseDiscountLabel.text = "\(entrantPass.merchandiseDiscount)% merchandise discount"
  }
  
  func setTextViewFor(success: Bool, message: AccessMessage) {
    let successColor = UIColor(red: 88/255.0, green: 149/255.0, blue: 143/255.0, alpha: 1.0)
    let failureColor = UIColor(red: 163/255.0, green: 96/255.0, blue: 106/255.0, alpha: 1.0)
    textView.backgroundColor = success ? successColor : failureColor
    self.textView.textColor = .white
    self.textView.text = message
  }
  
  // MARK: Test Area Access
  @IBAction func testAreaAccess() {
    let alertController = UIAlertController(title: "Test Access Areas", message: "What Area would you like to test access for?", preferredStyle: .alert)
    let amusementAction = UIAlertAction(title: AccessArea.amusement.rawValue.capitalized, style: .default) { _ in
      let result = self.cardReader.swipeAccess(self.entrantPass, hasAccessTo: .amusement)
      self.setTextViewFor(success: result.hasAccess, message: result.message)
    }
    let kitchenAction = UIAlertAction(title: AccessArea.kitchen.rawValue.capitalized, style: .default) { _ in
      let access = self.cardReader.swipeAccess(self.entrantPass, hasAccessTo: .kitchen)
      self.setTextViewFor(success: access.hasAccess, message: access.message)
    }
    let rideControlAction = UIAlertAction(title: AccessArea.rideControl.rawValue.capitalized, style: .default) { _ in
      let access = self.cardReader.swipeAccess(self.entrantPass, hasAccessTo: .rideControl)
      self.setTextViewFor(success: access.hasAccess, message: access.message)
    }
    let maintenanceAction = UIAlertAction(title: AccessArea.maintenance.rawValue.capitalized, style: .default) { _ in
      let access = self.cardReader.swipeAccess(self.entrantPass, hasAccessTo: .maintenance)
      self.setTextViewFor(success: access.hasAccess, message: access.message)
    }
    let officeAction = UIAlertAction(title: AccessArea.office.rawValue.capitalized, style: .default) { _ in
      let access = self.cardReader.swipeAccess(self.entrantPass, hasAccessTo: .office)
      self.setTextViewFor(success: access.hasAccess, message: access.message)
    }
    let actions = [amusementAction, kitchenAction, rideControlAction, maintenanceAction, officeAction]
    let _ = actions.map { alertController.addAction($0) }
    present(alertController, animated: true) { completion in
      self.textView.textColor = .white
    }
  }
  
  // MARK: Test Ride Access
  @IBAction func testRideAccess() {
    let alert = UIAlertController(title: "Test RideAccess", message: "What access would you like to test for?", preferredStyle: .alert)
    let allRides = UIAlertAction(title: "Unlimited Rides", style: .default) { _ in
      let access = self.cardReader.swipeAccess(self.entrantPass, hasRideAccess: .allRides(self.entrantPass.allRideAccess))
      self.setTextViewFor(success: access.hasAccess, message: access.message)
    }
    let skipsLines = UIAlertAction(title: "Skip Queues", style: .default) { _ in
      let access = self.cardReader.swipeAccess(self.entrantPass, hasRideAccess: .skipsQueues(self.entrantPass.skipsQueues))
      self.setTextViewFor(success: access.hasAccess, message: access.message)
    }
    let actions = [allRides, skipsLines]
    _ = actions.map { alert.addAction($0) }
    present(alert, animated: true, completion: nil)
  }
  
  // MARK: Test Discount Access
  @IBAction func testDiscountAccess() {
    let alert = UIAlertController(title: "Test Discount Access", message: "Choose a discount to test for", preferredStyle: .alert)
    let foodDiscount = UIAlertAction(title: "Food Discount", style: .default) { _ in
      let result = self.cardReader.swipeAccess(self.entrantPass, discountFor: .food(self.entrantPass.foodDiscount))
      self.setTextViewFor(success: result.hasAccess, message: result.message)
    }
    let merchandiseDiscount = UIAlertAction(title: "Merchandise Discount", style: .default) { _ in
      let result = self.cardReader.swipeAccess(self.entrantPass, discountFor: .merchandise(self.entrantPass.merchandiseDiscount))
      self.setTextViewFor(success: result.hasAccess, message: result.message)
    }
    let actions = [foodDiscount, merchandiseDiscount]
    _ = actions.map { alert.addAction($0) }
    present(alert, animated: true, completion: nil)
  }

  @IBAction func createNewPass() {
    entrantPass = nil
    dismiss(animated: true, completion: nil)
  }
  
  
  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      // Get the new view controller using segue.destinationViewController.
      // Pass the selected object to the new view controller.
  }
  */

}
