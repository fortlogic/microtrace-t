//
//  Extensions.swift
//  CTraceTests
//
//  Created by Matias Eyzaguirre on 2019-03-27.
//

import Foundation

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
