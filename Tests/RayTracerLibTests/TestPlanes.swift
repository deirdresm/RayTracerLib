//
//  TestPlanes.swift
//  
//
//  Created by Deirdre Saoirse Moen on 9/14/24.
//

import Foundation
import XCTest

@testable import RayTracerLib

final class TestPlanes: XCTestCase {

//	Scenario: The normal of a plane is constant everywhere
//	  Given p ← plane()
//	  When n1 ← local_normal_at(p, point(0, 0, 0))
//		And n2 ← local_normal_at(p, point(10, 0, -10))
//		And n3 ← local_normal_at(p, point(-5, 0, 150))
//	  Then n1 = vector(0, 1, 0)
//		And n2 = vector(0, 1, 0)
//		And n3 = vector(0, 1, 0)

	func testNormalOfPlaneIsConsistant() {
		let p = Plane()

		let n1 = p.normal(at: Point(0, 0, 0))
		let n2 = p.normal(at: Point(10, 0, -10))
		let n3 = p.normal(at: Point(-5, 0, 150))

		XCTAssertEqual(n1, Vector(0, 1, 0))
		XCTAssertEqual(n2, Vector(0, 1, 0))
		XCTAssertEqual(n3, Vector(0, 1, 0))
	}

//	Scenario: Intersect with a ray parallel to the plane
//	  Given p ← plane()
//		And r ← ray(point(0, 10, 0), vector(0, 0, 1))
//	  When xs ← local_intersect(p, r)
//	  Then xs is empty

	func testIntersetctWithRayParallelToPlane() {
		let p = Plane()
		let r = Ray(origin: Point(0, 10, 0), direction: Vector(0, 0, 1))

		let xs = p.localIntersects(r)

		XCTAssertEqual([], xs)
	}

//	Scenario: Intersect with a coplanar ray
//	  Given p ← plane()
//		And r ← ray(point(0, 0, 0), vector(0, 0, 1))
//	  When xs ← local_intersect(p, r)
//	  Then xs is empty

	func testIntersetctWithCoplanarRay() {
		let p = Plane()
		let r = Ray(origin: Point(0, 0, 0), direction: Vector(0, 0, 1))

		let xs = p.localIntersects(r)

		XCTAssertEqual([], xs)
	}

//	Scenario: A ray intersecting a plane from above
//	  Given p ← plane()
//		And r ← ray(point(0, 1, 0), vector(0, -1, 0))
//	  When xs ← local_intersect(p, r)
//	  Then xs.count = 1
//		And xs[0].t = 1
//		And xs[0].object = p

	func testRayIntersectsPlaneFromAbove() {
		let p = Plane()
		let r = Ray(origin: Point(0, 1, 0), direction: Vector(0, -1, 0))

		let xs = p.intersects(r)

		XCTAssertEqual(xs.count, 1)
		XCTAssertEqual(xs[0].distance, 1)
		XCTAssertEqual(xs[0].shape as! Plane, p)
	}

//	Scenario: A ray intersecting a plane from below
//	  Given p ← plane()
//		And r ← ray(point(0, -1, 0), vector(0, 1, 0))
//	  When xs ← local_intersect(p, r)
//	  Then xs.count = 1
//		And xs[0].t = 1
//		And xs[0].object = p

	func testRayIntersectsPlaneFromBelow() {
		let p = Plane()
		let r = Ray(origin: Point(0, -1, 0), direction: Vector(0, 1, 0))

		let xs = p.intersects(r)

		XCTAssertEqual(xs.count, 1)
		XCTAssertEqual(xs[0].distance, 1)
		XCTAssertEqual(xs[0].shape as! Plane, p)
	}

}
