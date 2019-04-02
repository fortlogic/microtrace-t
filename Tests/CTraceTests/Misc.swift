//
//  Misc.swift
//  CTraceTests
//
//  Created by Matias Eyzaguirre on 2019-03-27.
//

import Foundation
import SwiftCheck

extension Float {
  func integralDistance(to f: Float) -> Int {
    return self.bitPattern.distance(to: f.bitPattern)
  }

  func equal(to f: Float, within neighborhood: UInt) -> Bool {
    let distance = self.integralDistance(to: f)
    // look ma no branches
    return (self.isZero && f.isZero) || distance.magnitude <= neighborhood
  }
}

struct PythagoreanTriple: Arbitrary {
  let a, b, c: UInt

  var floats: (Float, Float, Float) {
    return (Float(a), Float(b), Float(c))
  }

  init(_ m: UInt, _ n: UInt) {
    assert(m > n, "m must be more than n to make a valid triple")
    a = (m * m) - (n * n)
    b = 2 * m * n
    c = (m * m) + (n * n)
  }

  static var arbitrary: Gen<PythagoreanTriple> {
    return Gen.zip(UInt.arbitrary, UInt.arbitrary).suchThat {
      (pair: (UInt, UInt)) in
      let (m, n) = pair
      return m > n
      }.map {
        (pair: (UInt, UInt)) in
        let (m, n) = pair
        return PythagoreanTriple(m, n)
    }
  }
}
