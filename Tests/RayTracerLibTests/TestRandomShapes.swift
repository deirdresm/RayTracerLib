//
//  TestSphere.swift
//  RayTracerTests
//
//  Created by Deirdre Saoirse Moen on 2/16/21.
//  Copyright © 2021 Deirdre Saoirse Moen. All rights reserved.
//

import XCTest
@testable import RayTracerLib

// swiftlint:disable identifier_name

import Foundation

class TestShape: Shape, Equatable {

	var id = UUID()
	var material: Material
	var description: String = ""
	var transform: Matrix

	var savedRay: Ray?

	public required init(material: Material, transform: Matrix = Matrix.identity) {
		self.material = material
		self.transform = transform
	}

	func setTransform(_ transform: Matrix) {
		self.transform = transform
	}

	func intersections(_ ray: Ray) -> [Intersection] {
		let intersection: Intersection? = localIntersect(ray)

		if let local = intersection {
			return [local]
		} else {
			return []
		}
	}

	func localIntersect(_ ray: Ray) -> Intersection? {
		let localRay = ray.transform(transform.inverse)

		if localRay.hit() != nil {
			savedRay = localRay
		}
		return savedRay?.hit()
	}

	func normal(at worldPoint: Point) -> Vector {
		let objectPoint = transform.inverse * worldPoint
		let objectNormal = objectPoint - Point(0, 0, 0)
		let worldNormal = transform.inverse.transpose() * objectNormal
		worldNormal.w = 0
		return worldNormal.normalize()
	}

	static func == (lhs: TestShape, rhs: TestShape) -> Bool {
		return lhs.id == rhs.id
	}
}


class TestSampleShapes: XCTestCase {

//    Scenario: The default transformation
//      Given s ← test_shape()
//      Then s.transform = identity_matrix

	func testDefaultTransform() {
		let m = Material()
		let s = TestShape(material: m)

		XCTAssertEqual(s.transform, Matrix.identity)
	}

//    Scenario: Assigning a transformation
//      Given s ← test_shape()
//      When set_transform(s, translation(2, 3, 4))
//      Then s.transform = translation(2, 3, 4)

	func testAssignedTransform() {
		let m = Material()
		let s = TestShape(material: m)
		s.transform = Matrix.translation(Point(2, 3, 4))

		XCTAssertEqual(s.transform, Matrix.translation(Point(2, 3, 4)))
	}

//    Scenario: The default material
//      Given s ← test_shape()
//      When m ← s.material
//      Then m = material()

	func testDefaultMaterial() {
		let m = Material()
		let s = TestShape(material: m)

		XCTAssertEqual(s.material, m)
	}

//    Scenario: Assigning a material
//      Given s ← test_shape()
//        And m ← material()
//        And m.ambient ← 1
//      When s.material ← m
//      Then s.material = m

	func testAssignedMaterial() {
		var m = Material()
		m.ambient = 1
		let s = TestShape(material: m)

		XCTAssertEqual(s.material, m)
		XCTAssertEqual(s.material.ambient, m.ambient)
	}

//    Scenario: Intersecting a scaled shape with a ray
//      Given r ← ray(point(0, 0, -5), vector(0, 0, 1))
//        And s ← test_shape()
//      When set_transform(s, scaling(2, 2, 2))
//        And xs ← intersect(s, r)
//      Then s.saved_ray.origin = point(0, 0, -2.5)
//        And s.saved_ray.direction = vector(0, 0, 0.5)

	func testScaledShapeIntersectsRay() throws {
		let r = Ray(origin: Point(0, 0, -5), direction: Vector(0, 0, 1))
		let shape = TestShape(material: Material())
		
		shape.setTransform(Matrix.scaling(point: Point(2, 2, 2)))
		let xs = shape.intersections(r)
	
		XCTAssertEqual(xs.count, 1)
		// FIXME: XCTAssertEqual failed: ("0") is not equal to ("1")

		let savedRay = try XCTUnwrap(shape.savedRay)
		// FIXME:  XCTUnwrap failed: expected non-nil value of type "Ray"

		XCTAssertEqual(savedRay.origin, Point(0, 0, -2.5))
		// FIXME: XCTAssertEqual failed: ("nil") is not equal to ("Optional(Point: x: 0, y: 0, z: -2.5, w: 1)")

		XCTAssertEqual(savedRay.direction, Vector(0, 0, 0.5))
		// FIXME: XCTAssertEqual failed: ("nil") is not equal to ("Optional(Vector: x: 0.0, y: 0.0, z: 0.5, w: 0.0)")

		// TODO: add another test case with a non-zero intersection count
	}

//    Scenario: Intersecting a translated shape with a ray
//      Given r ← ray(point(0, 0, -5), vector(0, 0, 1))
//        And s ← test_shape()
//      When set_transform(s, translation(5, 0, 0))
//        And xs ← intersect(s, r)
//      Then s.saved_ray.origin = point(-5, 0, -5)
//        And s.saved_ray.direction = vector(0, 0, 1)

	func testTranslatedShapeIntersectsRay() {
		 let r = Ray(origin: Point(0, 0, -5), direction: Vector(0, 0, 1))
		let shape = TestShape(material: Material())
		shape.transform = Matrix.scaling(point: Point(2, 2, 2))
		 let xs = shape.intersections(r)
		 XCTAssertEqual(xs.count, 0)

		 // TODO: add another test case with a non-zero intersection count
 }

//    Scenario: Computing the normal on a translated shape
//      Given s ← test_shape()
//      When set_transform(s, translation(0, 1, 0))
//        And n ← normal_at(s, point(0, 1.70711, -0.70711))
//      Then n = vector(0, 0.70711, -0.70711)
//
//    Scenario: Computing the normal on a transformed shape
//      Given s ← test_shape()
//        And m ← scaling(1, 0.5, 1) * rotation_z(π/5)
//      When set_transform(s, m)
//        And n ← normal_at(s, point(0, √2/2, -√2/2))
//      Then n = vector(0, 0.97014, -0.24254)
//
//    Scenario: A shape has a parent attribute
//      Given s ← test_shape()
//      Then s.parent is nothing
//
//    Scenario: Converting a point from world to object space
//      Given g1 ← group()
//        And set_transform(g1, rotation_y(π/2))
//        And g2 ← group()
//        And set_transform(g2, scaling(2, 2, 2))
//        And add_child(g1, g2)
//        And s ← sphere()
//        And set_transform(s, translation(5, 0, 0))
//        And add_child(g2, s)
//      When p ← world_to_object(s, point(-2, 0, -10))
//      Then p = point(0, 0, -1)
//
//    Scenario: Converting a normal from object to world space
//      Given g1 ← group()
//        And set_transform(g1, rotation_y(π/2))
//        And g2 ← group()
//        And set_transform(g2, scaling(1, 2, 3))
//        And add_child(g1, g2)
//        And s ← sphere()
//        And set_transform(s, translation(5, 0, 0))
//        And add_child(g2, s)
//      When n ← normal_to_world(s, vector(√3/3, √3/3, √3/3))
//      Then n = vector(0.2857, 0.4286, -0.8571)
//
//    Scenario: Finding the normal on a child object
//      Given g1 ← group()
//        And set_transform(g1, rotation_y(π/2))
//        And g2 ← group()
//        And set_transform(g2, scaling(1, 2, 3))
//        And add_child(g1, g2)
//        And s ← sphere()
//        And set_transform(s, translation(5, 0, 0))
//        And add_child(g2, s)
//      When n ← normal_at(s, point(1.7321, 1.1547, -5.5774))
//      Then n = vector(0.2857, 0.4286, -0.8571)

}
