//
//  Vector2Tests.swift
//  CTraceTests
//
//  Created by Matias Eyzaguirre on 2019-03-27.
//

import SwiftCheck
import XCTest

@testable import CTrace

///
/// Test Case
///

class Vector2Tests: XCTestCase {

  func test_zero() {
    XCTAssertEqual(vec2_zero.u, 0.0, "u component of zero should be zero")
    XCTAssertEqual(vec2_zero.v, 0.0, "v componnent of zero should be zero")
  }

  func test_unit_u() {
    XCTAssertEqual(vec2_unit_u.u, 1.0, "u component of u-hat should be one")
    XCTAssertEqual(vec2_unit_u.v, 0.0, "v component of u-hat should be zero")
  }

  func test_unit_v() {
    XCTAssertEqual(vec2_unit_v.u, 0.0, "u component of v-hat should be zero")
    XCTAssertEqual(vec2_unit_v.v, 1.0, "v component of v-hat should be one")
  }

  func test_make() {
    XCTFail("write me")
  }

  func test_magnitude() {
    XCTAssertEqual(vec2_magnitude(vec2_zero), 0.0, "length of zero is zero")
    XCTAssertEqual(vec2_magnitude(vec2_unit_u), 1.0, "length of u-hat is one")
    XCTAssertEqual(vec2_magnitude(vec2_unit_v), 1.0, "length of v-hat is one")

    property("magnitude obeys the triangle property") <- forAll {
      (vec: vector2) in
      return vec2_magnitude(vec) <= (vec.u.magnitude + vec.v.magnitude)
    }

    property("magnitude conforms with pythagorean triples") <- forAll {
      (m: UInt, n: UInt) in
      return (m > n) ==> {
        // Generate a pythagorean triple
        let a = Float((m * m) - (n * n))
        let b = Float(2 * m * n)
        let c = Float((m * m) + (n * n))

        return vec2_magnitude(vec2_make(a, b)) == c
      }
    }
  }

  func test_normalize() {
    XCTFail("write me")
  }

  func test_negate() {
    XCTFail("write me")
  }

  func test_scale() {
    XCTFail("write me")
  }

  func test_dot() {
    XCTFail("write me")
  }

  func test_distance() {
    XCTFail("write me")
  }

  func test_add() {
    XCTFail("write me")
  }

  func test_subtract() {
    XCTFail("write me")
  }

  func test_addn() {
    XCTFail("write me")
  }

  func test_subtractn() {
    XCTFail("write me")
  }

}

///
/// Test Support
///

extension vector2: Arbitrary, CustomStringConvertible, Equatable {
  public static var arbitrary: Gen<vector2> {
    return Gen.zip(Float.arbitrary, Float.arbitrary).map {
      (u,v) in
      var vec: vector2 = vec2_zero
      vec.u = u
      vec.v = v
      return vec
    }
  }

  public var description: String {
    return "<\(u), \(v)>"
  }

  public static func ==(lhs: vector2, rhs: vector2) -> Bool {
    return (lhs.u == rhs.u) && (lhs.v == rhs.v)
  }
}
