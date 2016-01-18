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



class ViewController: UITableViewController {
  let CellIdentifier = "cell"
  var solutions = [[MenuItem]]()

  override func viewDidLoad() {
    self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier)

    if let criteria = ProblemCriteria.fromFile("menu.json") {
      var waiter = Waiter(menuItems: criteria.menuItems)
      self.solutions = waiter.solve(criteria.targetPrice)
    }
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath)

    let section = self.solutions[indexPath.section]
    cell.textLabel?.text = section[indexPath.row].name

    return cell
  }

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return self.solutions.count
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.solutions[section].count
  }

  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Option \(section)"
  }
}

