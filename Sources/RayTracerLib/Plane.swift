//
//  Plane.swift
//  RayTracer
//
//  Created by Deirdre Saoirse Moen on 1/28/22.
//  Copyright © 2022 Deirdre Saoirse Moen. All rights reserved.
//

import Foundation

class Plane: Shape {
	var id = UUID()
	var material: Material
	var transform: Matrix

	var savedRay: Ray?

	init(_ material: Material = Material()) {
		self.material = material
		self.transform = Matrix.identity
	}

	var description: String {
		return "I'm on a chair in the sky."
	}

	func intersects(_ ray: Ray) -> [Intersection] {
		if abs(ray.direction.y) >= CGFloat.epsilon {
			return [Intersection(distance: -ray.origin.y / ray.direction.y, shape: self)]
		} else {
			return []
		}
	}

	func localIntersects(_ ray: Ray) ->  [Intersection] {
		return []
	}

	func normal(at worldPoint: Point) -> Vector {
		return Vector(0, 1, 0)
	}

	/// `==` for `Equatable` conformance.
	static func == (lhs: Plane, rhs: Plane) -> Bool {
		lhs.id == rhs.id
	}
}
