//
//  Waiter.swift
//  xkcd
//
//  Created by Table XI on 1/5/16.
//  Copyright © 2016 TableXI. All rights reserved.
//

import Foundation

struct Waiter {
  var menuItems: [MenuItem]
  private var solutions: [[MenuItem]] = [[MenuItem]]()

  init(menuItems: [MenuItem]) {
    self.menuItems = menuItems
  }

  mutating func solve(targetPrice: NSDecimalNumber) -> [[MenuItem]] {
    populateSolutions(targetPrice, currentSolution: [], items: menuItems)
    return solutions
  }

  mutating func populateSolutions(moneyLeft: NSDecimalNumber, currentSolution: [MenuItem], items: [MenuItem]) {
    // No items left
    if items.count == 0 {
      return
    }

    // Money left is less than zero
    if moneyLeft.compare(0) == .OrderedAscending {
      return
    }

    // Money left is zero
    if moneyLeft.compare(0) == .OrderedSame {
      // Solution isn't empty
      if currentSolution.count > 0 {
        // Sort current solution ascending on price
        let sortedAsc = currentSolution.sort { $0.price.compare($1.price) == .OrderedAscending }

        var contains = false
        for solution in solutions {
          if solution == sortedAsc {
            contains = true
            break
          }
        }

        // Solution doesn't already exist
        if !contains {
          solutions.append(sortedAsc)
        }
      }
      return
    }

    // Money left is greater than zero
    _ = items.map { item in
      let newMoneyLeft = moneyLeft.decimalNumberBySubtracting(item.price)

      var newCurrentSolution = currentSolution
      newCurrentSolution.append(item)

      var newItems = items
      if moneyLeft.compare(0) == .OrderedAscending {
        newItems = Array(items[1..<items.count])
      }

      populateSolutions(newMoneyLeft, currentSolution: newCurrentSolution, items: newItems)
    }
  }
}