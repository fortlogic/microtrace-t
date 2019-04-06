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

extension UInt {
  func gcd(of n: UInt) -> UInt {
    if self == n {
      return self
    } else if self > n {
      return (self - n).gcd(of: n)
    } else if self < n {
      return self.gcd(of:n - self)
    }
    preconditionFailure("Two UInts should be comparable")
  }
}

struct PythagoreanTriple: Arbitrary {
  let a, b, c: UInt

  var floats: (Float, Float, Float) {
    return (Float(a), Float(b), Float(c))
  }

  init?(_ m: UInt, _ n: UInt) {
    if m > n {
      a = (m * m) - (n * n)
      b = 2 * m * n
      c = (m * m) + (n * n)
    } else {
      return nil
    }
  }

  static var arbitrary: Gen<PythagoreanTriple> {
    return Gen.zip(UInt.arbitrary, UInt.arbitrary).suchThat {
      (pair: (UInt, UInt)) in
      let (m, n) = pair
      return m > n
      }.map {
        (pair: (UInt, UInt)) in
        let (m, n) = pair
        return PythagoreanTriple(m, n)!
    }
  }
}

// Generating quads reliably is broken
//struct PythagoreanQuadruple: Arbitrary {
//  let a, b, c, d: UInt
//
//  var floats: (Float, Float, Float, Float) {
//    return (Float(a), Float(b), Float(c), Float(d))
//  }
//
//  init?(_ m: UInt, _ n: UInt, _ p: UInt, _ q: UInt) {
//    if (m + n + p + q) % 2 == 1 {
//      a = (m * m) + (n * n) - (p * p) - (q * q)
//      b = 2 * ((m * q) + (n * p))
//      c = 2 * ((n * q) - (m * p))
//      d = (m * m) + (n * n) + (p * p) + (q * q)
//      assert(((a * a) + (b * b) + (c * c)) == (d * d))
//    }
//    return nil
//  }
//
//  static var arbitrary: Gen<PythagoreanQuadruple> {
//    return Gen.zip(UInt.arbitrary, UInt.arbitrary, UInt.arbitrary, UInt.arbitrary).suchThat {
//      (pair: (UInt, UInt, UInt, UInt)) in
//      let (m, n, p, q) = pair
//      return (m + n + p + q) % 2 == 1
//      }.map {
//        (pair: (UInt, UInt, UInt, UInt)) in
//        let (m, n, p, q) = pair
//        return PythagoreanQuadruple(m, n, p, q)!
//    }
//  }
//}
