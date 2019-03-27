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
    XCTFail("write me")
  }

  func test_magnitude() {
    XCTAssertEqual(vec3_magnitude(vec3_zero), 0.0, "length of zero is zero")
    XCTFail("length of unit_u")
    XCTFail("length of unit_v")
    XCTFail("length obeys the triangle property")
    XCTFail("Pythagorean triples behave nicely")
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

extension vector3 {
  
}
