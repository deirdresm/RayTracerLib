//
//  TestShape.swift
//
//
//  Created by Deirdre Saoirse Moen on 9/2/24.
//

import Foundation

class TestShape: Shape, Equatable {
	var id = UUID()
	var material: Material
	var description: String = ""
	var transform: Matrix {
		didSet {
			inverseTransform = transform.inverse
		}
	}
	private(set) var inverseTransform = Matrix.identity

	var savedRay: Ray?

	init(transform: Matrix = Matrix.identity,
		 material: Material = Material()) {
		self.transform = transform
		self.material = material
	}

	func intersects(_ ray: Ray) -> [Intersection] {
		let localRay = ray.transform(transform.inverse)
		savedRay = localRay
		return []
	}

	func localIntersects(_ ray: Ray) -> [Intersection] {
		savedRay = ray
		return []
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
