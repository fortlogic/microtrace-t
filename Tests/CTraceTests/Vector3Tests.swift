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
    XCTFail("length of unit_i")
    XCTFail("length of unit_j")
    XCTFail("length of unit_k")
    XCTFail("length obeys the triangle property")
    XCTFail("Pythagorean triples behave nicely")
  }

  func test_normalize() {
    XCTFail("zero vector is <nan,nan>")
    XCTFail("basis unit vector i normalise to themselves")
    XCTFail("basis unit vector j normalise to themselves")
    XCTFail("basis unit vector k normalise to themselves")
    XCTFail("vec and vec.normalised are in the same direction")
    XCTFail("the result of a normalised vector has length one")
  }

  func test_negate() {
    XCTFail("negate zero is zero")
    XCTFail("negate basis i")
    XCTFail("negate basis j")
    XCTFail("negate basis k")
    XCTFail("negate reverses coordinates")
    XCTFail("double negation is identity")
  }

  func test_scale() {
    XCTFail("scaling zero is zero")
    XCTFail("scaling by zero is zero")
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

extension vector3 {
  
}
