//
//  WaiterSpec.swift
//  xkcd
//
//  Created by Table XI on 1/5/16.
//  Copyright © 2016 TableXI. All rights reserved.
//

@testable import xkcd
import Quick
import Nimble

class WaiterSpec: QuickSpec {
  override func spec() {
    describe("solve") {
      var waiter: Waiter!
      var item1: MenuItem!
      var item2: MenuItem!
      var item3: MenuItem!

      beforeEach {
        item1 = MenuItem(name: "item 1", price: 1.00)
        item2 = MenuItem(name: "item 2", price: 2.00)
        item3 = MenuItem(name: "item 3", price: 3.00)

        waiter = Waiter(menuItems: [item1, item2, item3])
      }

      it("handles zero target price") {
        expect(waiter.solve(0).count).to(equal(0))
      }

      it("handles a single item solution") {
        let solution = waiter.solve(1.0)
        expect(solution.count).to(equal(1))
        expect(solution[0]).to(equal([item1]))
      }

      it("handles a two item solution") {
        let solution = waiter.solve(2.0)
        expect(solution.count).to(equal(2))
        expect(solution[0]).to(equal([item1, item1]))
        expect(solution[1]).to(equal([item2]))
      }

      it("handles a repeated solution") {
        // Should contain [item1, item2] but not [item2, item1]
        let solution = waiter.solve(3.0)
        expect(solution.count).to(equal(3))
        expect(solution[0]).to(equal([item1, item1, item1]))
        expect(solution[1]).to(equal([item1, item2]))
        expect(solution[2]).to(equal([item3]))
      }

      it("handles a target larger than the most expensive item") {
        let solution = waiter.solve(4.0)
        expect(solution.count).to(equal(4))
        expect(solution[0]).to(equal([item1, item1, item1, item1]))
        expect(solution[1]).to(equal([item1, item1, item2]))
        expect(solution[2]).to(equal([item1, item3]))
        expect(solution[3]).to(equal([item2, item2]))
      }
    }
  }
}