//
//  MenuItem.swift
//  xkcd
//
//  Created by Table XI on 1/18/16.
//  Copyright © 2016 TableXI. All rights reserved.
//

import Foundation

struct MenuItem {
  var name: String
  var price: NSDecimalNumber
}
extension MenuItem: Equatable {}
func == (lhs: MenuItem, rhs: MenuItem) -> Bool {
  return lhs.name == rhs.name && lhs.price == rhs.price
}