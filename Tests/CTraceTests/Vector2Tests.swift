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
    property("makes builds vectors") <- forAll {
      (u: Float, v: Float) in
      let vec = vec2_make(u, v)
      return ((vec.u == u) <?> "u") ^&&^ ((vec.v == v) <?> "v")
    }
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
    XCTAssertTrue(vec2_normalize(vec2_zero).u.isNaN, "Normalizing zero is NaN (u)")
    XCTAssertTrue(vec2_normalize(vec2_zero).v.isNaN, "Normalizing zero is NaN (v)")

    XCTAssertEqual(vec2_normalize(vec2_unit_u), vec2_unit_u, "u-hat normalizes to itself")
    XCTAssertEqual(vec2_normalize(vec2_unit_v), vec2_unit_v, "v-hat normalizes to itself")

    property("normalization preserves direction") <- forAll {
      (vec: vector2) in
      return (!vec.isZero) ==> {
        let vecUnit = vec2_normalize(vec)
        // this requires that the dot product is correct
        return vec2_dot(vec, vecUnit).equal(to: vec2_magnitude(vec), within: 4)
      }
    }

    property("normalisation results in magnitude one") <- forAll {
      (vec: vector2) in
      return (!vec.isZero) ==> {
        return vec2_magnitude(vec2_normalize(vec)).equal(to: 1.0, within: 2)
      }
    }
  }

  func test_negate() {
    XCTAssertEqual(vec2_negate(vec2_zero), vec2_zero, "negative zero is zero")
    XCTAssertEqual(vec2_negate(vec2_unit_u), vec2_make(-1.0, 0.0), "negative u-hat")
    XCTAssertEqual(vec2_negate(vec2_unit_v), vec2_make(0.0, -1.0), "negative v-hat")

    property("double negation is an identity") <- forAll {
      (vec: vector2) in
      return vec == vec2_negate(vec2_negate(vec))
    }

    property("negation negates coordinates") <- forAll {
      (vec: vector2) in
      let neg = vec2_negate(vec)

      return ((-vec.u == neg.u) <?> "u") ^&&^ ((-vec.v == neg.v) <?> "v")
    }
  }

  func test_scale() {
    property("scaling zero gives zero") <- forAll {
      (s: Float) in
      return vec2_scale(s, vec2_zero) == vec2_zero
    }

    property("scaling by zero gives zero") <- forAll {
      (vec: vector2) in
      return vec2_scale(0.0, vec) == vec2_zero
    }

    property("scaling by one is the identity") <- forAll {
      (vec: vector2) in
      return vec2_scale(1.0, vec) == vec
    }

    property("scaling by -1 negates") <- forAll {
      (vec: vector2) in
      // this requires that negation is correct
      return vec2_scale(-1.0, vec) == vec2_negate(vec)
    }

    property("scaling scales coordinates") <- forAll {
      (s: Float, vec: vector2) in
      let scaled = vec2_scale(s, vec)
      return ((scaled.u == s * vec.u) <?> "u") ^&&^ ((scaled.v == s * vec.v) <?> "v")
    }
  }

  func test_dot() {
    XCTAssertEqual(vec2_dot(vec2_zero, vec2_zero), 0.0, "zero dot zero is zero")
    XCTAssertEqual(vec2_dot(vec2_unit_u, vec2_unit_v), 0.0, "u-hat should be orthogonal to v-hat")

    property("dotting with u-hat extracts the u component") <- forAll {
      (vec: vector2) in
      return vec2_dot(vec, vec2_unit_u) == vec.u
    }

    property("dotting with v-hat extracts the v component") <- forAll {
      (vec: vector2) in
      return vec2_dot(vec, vec2_unit_v) == vec.v
    }

    property("the dot product is commutative") <- forAll {
      (vec1: vector2, vec2: vector2) in
      return vec2_dot(vec1, vec2) == vec2_dot(vec2, vec1)
    }

    property("the dot product scales") <- forAll {
      (s1: Float, s2: Float, vec1: vector2, vec2: vector2) in
      let dotScale = vec2_dot(vec2_scale(s1, vec1), vec2_scale(s2, vec2))
      let scaleDot = s1 * s2 * vec2_dot(vec1, vec2)

      return (!dotScale.isZero && !scaleDot.isZero) ==> {
        return dotScale.equal(to: scaleDot, within: 64)
      }
    }

    property("dot product agrees with geometric interpretation") <- forAll {
      (vec1: vector2, vec2: vector2) in
      return (!vec1.isZero && !vec2.isZero) ==> {
        let geoDot = vec2_magnitude(vec1) * vec2_magnitude(vec2) * cos((vec1.angle - vec2.angle).magnitude)
        return vec2_dot(vec1, vec2).equal(to: geoDot, within: 256)
      }
    }

  }

  func test_distance() {
    XCTFail("distance from zero is magnitude")
    XCTFail("triangle property")
    XCTFail("offset pythagorean triples")
    XCTFail("distance commutes")
  }

  func test_add() {
    XCTFail("zero is additive identity")
    XCTFail("addition commutes")
    XCTFail("coordinates get added")
  }

  func test_subtract() {
    XCTFail("zero is identity")
    XCTFail("negationg cancels out")
    XCTFail("|a-b| = |b-a|")
    XCTFail("coordinates subtract")
  }

//  func test_addn() {
//  }

//  func test_subtractn() {
//  }

}

///
/// Test Support
///

extension vector2 {
  var isZero: Bool {
    return self == vec2_zero
  }

  var angle: Float {
    // https://en.wikipedia.org/wiki/Polar_coordinate_system#Converting_between_polar_and_Cartesian_coordinates
    if u > 0.0 {
      return atan(v / u)
    } else if u < 0.0 {
      return atan(v / u) + (((v >= 0.0) ? 1.0 : -1.0) * Float.pi)
    } else {
      if v > 0 {
        return Float.pi / 2.0
      } else if v < 0 {
        return Float.pi / -2.0
      } else {
        return Float.nan
      }
    }
  }
}

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
