//
//  TestPassController.swift
//  AmusementparkPassGeneratorPart2
//
//  Created by Katherine Ebel on 11/15/16.
//  Copyright © 2016 Katherine Ebel. All rights reserved.
//

import UIKit

class TestPassController: UIViewController {
  
  var entrantPass: PassType! = nil

  override func viewDidLoad() {
    super.viewDidLoad()
    print(entrantPass.accessAreas)
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
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
