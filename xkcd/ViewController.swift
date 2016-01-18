//
//  ViewController.swift
//  xkcd
//
//  Created by Table XI on 1/5/16.
//  Copyright © 2016 TableXI. All rights reserved.
//

import UIKit
import SwiftyJSON

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

