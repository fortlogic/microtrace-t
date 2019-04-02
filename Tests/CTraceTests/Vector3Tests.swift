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

    XCTFail("length obeys the triangle property")
    XCTFail("Pythagorean triples behave nicely")
  }

  func test_normalize() {
    XCTAssertTrue(vec3_normalize(vec3_zero).i.isNaN, "zero shouldn't normalize (i)")
    XCTAssertTrue(vec3_normalize(vec3_zero).j.isNaN, "zero shouldn't normalize (j)")
    XCTAssertTrue(vec3_normalize(vec3_zero).k.isNaN, "zero shouldn't normalize (k)")

    XCTAssertEqual(vec3_normalize(vec3_unit_i), vec3_unit_i, "i-hat normalizes to itself")
    XCTAssertEqual(vec3_normalize(vec3_unit_j), vec3_unit_j, "i-hat normalizes to itself")
    XCTAssertEqual(vec3_normalize(vec3_unit_k), vec3_unit_k, "i-hat normalizes to itself")

    XCTFail("vec and vec.normalised are in the same direction")
    XCTFail("the result of a normalised vector has length one")
  }

  func test_negate() {
    XCTAssertEqual(vec3_negate(vec3_zero), vec3_zero, "negative zero is zero")
    XCTAssertEqual(vec3_negate(vec3_unit_i),
                   vec3_make(-1.0, 0.0, 0.0), "negative i-hat")
    XCTAssertEqual(vec3_negate(vec3_unit_j),
                   vec3_make(0.0, -1.0, 0.0), "negative j-hat")
    XCTAssertEqual(vec3_negate(vec3_unit_k),
                   vec3_make(0.0, 0.0, -1.0), "negative k-hat")

    property("double negation is an identity") <- forAll {
      (vec: vector3) in
      return vec == vec3_negate(vec3_negate(vec))
    }

    XCTFail("negate reverses coordinates")
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

    XCTFail("scaling basis i")
    XCTFail("scaling basis j")
    XCTFail("scaling basis k")
    XCTFail("scaling by one is identity")
    XCTFail("scaling by -1 is negation")
    XCTFail("scaling scales")
  }

  func test_dot() {
    XCTFail("dot zero is zero")
    XCTFail("basis vectors ij are orthogonal")
    XCTFail("basis vectors jk are orthogonal")
    XCTFail("basis vectors ki are orthogonal")
    XCTFail("dotting with basis vector i extracts coordinates")
    XCTFail("dotting with basis vector j extracts coordinates")
    XCTFail("dotting with basis vector k extracts coordinates")
    XCTFail("dot commutes")
    XCTFail("scaling one of the vectors scales the dot product")
    XCTFail("mag a * mag b * cos theta")
  }

  func test_distance() {
    XCTFail("distance from zero is magnitude")
    XCTFail("triangle property")
    XCTFail("offset pythagorean triples")
    XCTFail("distance commutes")
  }

  func test_add() {
    XCTFail("zero is additive identity")

    property("addition commutes") <- forAll {
      (vec1: vector3, vec2: vector3) in
      return vec3_add(vec1, vec2) == vec3_add(vec2, vec1)
    }

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

extension vector3 {
  
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
