//
//  Vector3Tests.swift
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

class Vector3Tests: XCTestCase {

  func test_zero() {
    XCTAssertEqual(vec3_zero.i, 0.0, "i component of zero should be zero")
    XCTAssertEqual(vec3_zero.j, 0.0, "j componnent of zero should be zero")
    XCTAssertEqual(vec3_zero.k, 0.0, "k componnent of zero should be zero")
  }

  func test_unit_i() {
    XCTAssertEqual(vec3_unit_i.i, 1.0, "i component of i-hat should be one")
    XCTAssertEqual(vec3_unit_i.j, 0.0, "j component of i-hat should be zero")
    XCTAssertEqual(vec3_unit_i.k, 0.0, "k component of i-hat should be zero")
  }

  func test_unit_j() {
    XCTAssertEqual(vec3_unit_j.i, 0.0, "i component of j-hat should be zero")
    XCTAssertEqual(vec3_unit_j.j, 1.0, "j component of j-hat should be one")
    XCTAssertEqual(vec3_unit_j.k, 0.0, "k component of j-hat should be zero")
  }

  func test_unit_k() {
    XCTAssertEqual(vec3_unit_k.i, 0.0, "i component of k-hat should be zero")
    XCTAssertEqual(vec3_unit_k.j, 0.0, "j component of k-hat should be zero")
    XCTAssertEqual(vec3_unit_k.k, 1.0, "k component of k-hat should be one")
  }

  func test_make() {
    property("makes builds vectors") <- forAll {
      (i: Float, j: Float, k: Float) in
      let vec = vec3_make(i, j, k)
      return ((vec.i == i) <?> "i") ^&&^ ((vec.j == j) <?> "j") ^&&^ ((vec.k == k) <?> "k")
    }
  }

  func test_magnitude() {
    XCTAssertEqual(vec3_magnitude(vec3_zero), 0.0, "length of zero is zero")
    XCTAssertEqual(vec3_magnitude(vec3_unit_i), 1.0, "length of i-hat is one")
    XCTAssertEqual(vec3_magnitude(vec3_unit_j), 1.0, "length of j-hat is one")
    XCTAssertEqual(vec3_magnitude(vec3_unit_k), 1.0, "length of k-hat is one")

    property("magnitude obeys the triangle property") <- forAll {
      (vec: vector3) in
      return vec3_magnitude(vec) <= (vec.i.magnitude + vec.j.magnitude + vec.k.magnitude)
    }

//    property("magnitude conforms with pythagorean quadruples") <- forAll {
//      (quad: PythagoreanQuadruple) in
//      let (a, b, c, d) = quad.floats
//      return vec3_magnitude(vec3_make(a, b, c)) == d
//    }
  }

  func test_normalize() {
    XCTAssertTrue(vec3_normalize(vec3_zero).i.isNaN, "zero shouldn't normalize (i)")
    XCTAssertTrue(vec3_normalize(vec3_zero).j.isNaN, "zero shouldn't normalize (j)")
    XCTAssertTrue(vec3_normalize(vec3_zero).k.isNaN, "zero shouldn't normalize (k)")

    XCTAssertEqual(vec3_normalize(vec3_unit_i), vec3_unit_i, "i-hat normalizes to itself")
    XCTAssertEqual(vec3_normalize(vec3_unit_j), vec3_unit_j, "i-hat normalizes to itself")
    XCTAssertEqual(vec3_normalize(vec3_unit_k), vec3_unit_k, "i-hat normalizes to itself")

    property("normalization preserves direction") <- forAll {
      (vec: vector3) in
      return (!vec.isZero) ==> {
        let vecUnit = vec3_normalize(vec)
        // this requires that the dot product is correct
        return vec3_dot(vec, vecUnit).equal(to: vec3_magnitude(vec), within: 4)
      }
    }

    property("normalisation results in magnitude one") <- forAll {
      (vec: vector3) in
      return (!vec.isZero) ==> {
        return vec3_magnitude(vec3_normalize(vec)).equal(to: 1.0, within: 3)
      }
    }
  }

  func test_negate() {
    XCTAssertEqual(vec3_negate(vec3_zero), vec3_zero, "negative zero is zero")
    XCTAssertEqual(vec3_negate(vec3_unit_i), vec3_make(-1.0, 0.0, 0.0), "negative i-hat")
    XCTAssertEqual(vec3_negate(vec3_unit_j), vec3_make(0.0, -1.0, 0.0), "negative j-hat")
    XCTAssertEqual(vec3_negate(vec3_unit_k), vec3_make(0.0, 0.0, -1.0), "negative k-hat")

    property("double negation is an identity") <- forAll {
      (vec: vector3) in
      return vec == vec3_negate(vec3_negate(vec))
    }

    property("negation negates coordinates") <- forAll {
      (vec: vector3) in
      let neg = vec3_negate(vec)

      return ((-vec.i == neg.i) <?> "i")
        ^&&^ ((-vec.j == neg.j) <?> "j")
        ^&&^ ((-vec.k == neg.k) <?> "k")
    }
  }

  func test_scale() {
    property("scaling zero is zero") <- forAll {
      (s: Float) in
      return vec3_scale(s, vec3_zero) == vec3_zero
    }

    property("scaling by zero is zero") <- forAll {
      (vec: vector3) in
      return vec3_scale(0.0, vec) == vec3_zero
    }

    property("scaling by 1 is the identity") <- forAll {
      (v: vector3) in
      return vec3_scale(1.0, v) == v
    }

    property("scaling by -1 negates") <- forAll {
      (vec: vector3) in
      // this requires that negation is correct
      return vec3_scale(-1.0, vec) == vec3_negate(vec)
    }

    property("scaling scales coordinates") <- forAll {
      (s: Float, vec: vector3) in
      let scaled = vec3_scale(s, vec)

      return ((s * vec.i == scaled.i) <?> "i")
        ^&&^ ((s * vec.j == scaled.j) <?> "j")
        ^&&^ ((s * vec.k == scaled.k) <?> "k")
    }
  }

  func test_dot() {
    XCTAssertEqual(vec3_dot(vec3_zero, vec3_zero), 0.0, "zero dot zero is zero")
    XCTAssertEqual(vec3_dot(vec3_unit_i, vec3_unit_j), 0.0, "i-hat should be orthogonal to j-hat")
    XCTAssertEqual(vec3_dot(vec3_unit_j, vec3_unit_k), 0.0, "j-hat should be orthogonal to k-hat")
    XCTAssertEqual(vec3_dot(vec3_unit_k, vec3_unit_i), 0.0, "k-hat should be orthogonal to i-hat")

    property("dotting with i-hat extracts the i component") <- forAll {
      (vec: vector3) in
      return vec3_dot(vec, vec3_unit_i) == vec.i
    }

    property("dotting with j-hat extracts the j component") <- forAll {
      (vec: vector3) in
      return vec3_dot(vec, vec3_unit_j) == vec.j
    }

    property("dotting with k-hat extracts the k component") <- forAll {
      (vec: vector3) in
      return vec3_dot(vec, vec3_unit_k) == vec.k
    }

    property("the dot product is commutative") <- forAll {
      (vec1: vector3, vec2: vector3) in
      return vec3_dot(vec1, vec2) == vec3_dot(vec2, vec1)
    }

    // The following are copied from the vector2 tests. Those tests are unreliable, implementing them
    // for vector3 would be premature until the vector2 versions are reliable.

    //    property("the dot product scales") <- forAll {
    //      (s1: Float, s2: Float, vec1: vector2, vec2: vector2) in
    //      let dotScale = vec2_dot(vec2_scale(s1, vec1), vec2_scale(s2, vec2))
    //      let scaleDot = s1 * s2 * vec2_dot(vec1, vec2)
    //
    //      return (!dotScale.isZero && !scaleDot.isZero) ==> {
    //        return dotScale.equal(to: scaleDot, within: 64)
    //      }
    //    }

    //    property("dot product agrees with geometric interpretation") <- forAll {
    //      (vec1: vector2, vec2: vector2) in
    //      return (!vec1.isZero && !vec2.isZero) ==> {
    //        let geoDot = vec2_magnitude(vec1) * vec2_magnitude(vec2) * cos((vec1.angle - vec2.angle).magnitude)
    //        return vec2_dot(vec1, vec2).equal(to: geoDot, within: 256)
    //      }
    //    }
  }

  func test_distance() {
    property("distance from 0 is magnitude") <- forAll {
      (v: vector3) in
      return vec3_distance(v, vec3_zero) == vec3_magnitude(v)
    }

    property("triangle property holds") <- forAll {
      (a: vector3, b: vector3, c: vector3) in
      return vec3_distance(a, c) <= (vec3_distance(a, b) + vec3_distance(b, c))
    }
    
    property("distance is commutative") <- forAll {
      (vec1: vector3, vec2: vector3) in
      return vec3_distance(vec1, vec2) == vec3_distance(vec2, vec1)
    }

//    property("distance agrees with pythagorean quadruples") <- forAll {
//      (i: UInt, j: UInt, k: UInt, quad: PythagoreanQuadruple) in
//      // this requires vec2_add to be correct
//      let (a, b, c, d) = quad.floats
//      let v1 = vec3_make(Float(i), Float(j), Float(k))
//      let v2 = vec3_add(v1, vec3_make(a, b, c))
//      return vec3_distance(v1, v2) == d
//    }
  }

  func test_add() {
    property("zero is the additive identity") <- forAll {
      (v: vector3) in
      return vec3_add(v, vec3_zero) == v
    }

    property("a+(-a)=0") <- forAll {
      (v: vector3) in
      return vec3_add(v, vec3_negate(v)) == vec3_zero
    }

    property("addition commutes") <- forAll {
      (vec1: vector3, vec2: vector3) in
      return vec3_add(vec1, vec2) == vec3_add(vec2, vec1)
    }

    property("addition adds coordinates") <- forAll {
      (vec1: vector3, vec2: vector3) in
      let sum = vec3_add(vec1, vec2)
      return ((sum.i == (vec1.i + vec2.i)) <?> "i")
        ^&&^ ((sum.j == (vec1.j + vec2.j)) <?> "j")
        ^&&^ ((sum.k == (vec1.k + vec2.k)) <?> "k")
    }
  }

  func test_subtract() {
    property("zero is the subtractive identity") <- forAll {
      (v: vector3) in
      return vec3_subtract(v, vec3_zero) == v
    }
    
    property("a - a = 0") <- forAll {
      (vec: vector3) in
      return vec3_subtract(vec, vec) == vec3_zero
    }

    property("|a-b|=|b-a|") <- forAll {
      (v1: vector3, v2: vector3) in
      let diff1 = vec3_magnitude(vec3_subtract(v1, v2))
      let diff2 = vec3_magnitude(vec3_subtract(v2, v1))
      return diff1 == diff2
    }

    property("subtraction subtracts coordinates") <- forAll {
      (vec1: vector3, vec2: vector3) in
      let diff = vec3_subtract(vec1, vec2)
      return ((diff.i == (vec1.i - vec2.i)) <?> "i")
        ^&&^ ((diff.j == (vec1.j - vec2.j)) <?> "j")
        ^&&^ ((diff.k == (vec1.k - vec2.k)) <?> "k")
    }
  }

//  func test_addn() {
//  }

//  func test_subtractn() {
//  }

}

///
/// Test Support
///

extension vector3 {
  var isZero: Bool {
    return self == vec3_zero
  }
}

extension vector3: Arbitrary, CustomStringConvertible, Equatable {
  public static var arbitrary: Gen<vector3> {
    return Gen.zip(vector2.arbitrary, Float.arbitrary).map {
      (vec2, k) in
      var vec: vector3 = vec3_zero
      vec.i = vec2.u
      vec.j = vec2.v
      vec.k = k
      return vec
    }
  }

  public var description: String {
    return "<\(i), \(j), \(k)>"
  }

  public static func ==(lhs: vector3, rhs: vector3) -> Bool {
    return (lhs.i == rhs.i) && (lhs.j == rhs.j) && (lhs.k == rhs.k)
  }
}
