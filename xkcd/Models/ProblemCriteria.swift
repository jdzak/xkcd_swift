//
//  ProblemCriteria.swift
//  xkcd
//
//  Created by Table XI on 1/18/16.
//  Copyright © 2016 TableXI. All rights reserved.
//

import Foundation

struct ProblemCriteria {
  var targetPrice: NSDecimalNumber
  var menuItems: [MenuItem]

  static func fromFile(fileName: String) -> ProblemCriteria? {
    let componants = fileName.componentsSeparatedByString(".")
    guard let filePath = NSBundle.mainBundle().pathForResource(componants[0], ofType: componants[1]) else {
      return nil
    }

    guard let fileData = NSData(contentsOfFile: filePath) else {
      return nil
    }

    let json = JSON(data: fileData)

    return self.fromJson(json)
  }

  static func fromJson(json: JSON) -> ProblemCriteria {
    let targetPrice = NSDecimalNumber(string: self.removeDollarSign(json["target_price"].stringValue))

    var menuItems = [MenuItem]()
    for menuItemJson in json["items"].arrayValue {
      let dict = menuItemJson.dictionaryValue
      if let name = dict["name"]?.stringValue, priceStr = dict["price"]?.string {
        let price = NSDecimalNumber(string: removeDollarSign(priceStr))
        menuItems.append(MenuItem(name: name, price: price))
      }
    }

    return ProblemCriteria(targetPrice: targetPrice, menuItems: menuItems)
  }

  static func removeDollarSign(price: String) -> String {
    return price.stringByReplacingOccurrencesOfString("$", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
  }
}
