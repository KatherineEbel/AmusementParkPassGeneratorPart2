//
//  DiscountType.swift
//  AmusementParkPassGenerator
//
//  Created by Katherine Ebel on 11/4/16.
//  Copyright © 2016 Katherine Ebel. All rights reserved.
//

typealias Percent = Int

enum DiscountType {
  case food(Percent)
  case merchandise(Percent)
}

extension DiscountType {
  var discount: Percent {
    switch self {
      case .food(let percent): return percent
      case .merchandise(let percent): return percent
    }
  }
}
