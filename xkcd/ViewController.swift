//
//  ViewController.swift
//  xkcd
//
//  Created by Table XI on 1/5/16.
//  Copyright © 2016 TableXI. All rights reserved.
//

import UIKit
import SwiftyJSON

struct MenuItem {
  var name: String
  var price: NSDecimalNumber
}
extension MenuItem: Equatable {}
func == (lhs: MenuItem, rhs: MenuItem) -> Bool {
  return lhs.name == rhs.name && lhs.price == rhs.price
}

struct ProblemCriteria {
  var targetPrice: NSDecimalNumber
  var menuItems: [MenuItem]

  static func fromFile(fileName: String) -> ProblemCriteria? {

    guard let filePath = NSBundle.mainBundle().pathForResource(fileName, ofType: "json") else {
      return nil
    }

    guard let fileData = NSData(contentsOfFile: filePath) else {
      return nil
    }

    let json = JSON(data: fileData)

    return self.fromJson(json)
  }

  static func fromJson(json: JSON) -> ProblemCriteria {
    let targetPrice = NSDecimalNumber(decimal: json["target_price"].numberValue.decimalValue)

    var menuItems = [MenuItem]()
    for menuItemJson in json["items"].arrayValue {
      let dict = menuItemJson.dictionaryValue
      if let name = dict["name"]?.stringValue, price = dict["price"]?.numberValue {
        let price = NSDecimalNumber(decimal: price.decimalValue)
        menuItems.append(MenuItem(name: name, price: price))
      }
    }

    return ProblemCriteria(targetPrice: targetPrice, menuItems: menuItems)
  }
}



class ViewController: UITableViewController {
  let CellIdentifier = "cell"
  let stuff = ["foo", "bar", "baz"]

  override func viewDidLoad() {
    self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier)

    if let criteria = ProblemCriteria.fromFile("menu.json") {
      var waiter = Waiter(menuItems: criteria.menuItems)
      waiter.solve(criteria.targetPrice)
    }
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath)

    cell.textLabel?.text = self.stuff[indexPath.row]

    return cell
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.stuff.count
  }
}

