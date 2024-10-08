//
//  Sphere.swift
//  RayTracerTests
//
//  Created by Deirdre Saoirse Moen on 2/16/21.
//  Copyright © 2021 Deirdre Saoirse Moen. All rights reserved.
//

import Foundation

// swiftlint:disable identifier_name

class Sphere: Shape, Equatable {
    var id = UUID()
    var origin: Point
    var radius: CGFloat
    var transform: Matrix
	var material: Material

	var savedRay: Ray?


	init(origin: Point = Point(0, 0, 0),
		 radius: CGFloat = 1.0,
		 transform: Matrix = Matrix.identity,
		 material: Material = Material()) {
        self.origin = origin
        self.radius = radius
        self.transform = transform
		self.material = material
    }

    // 
    func intersects(_ ray: Ray) -> [Intersection] {
        let localRay = ray.transform(transform.inverse)
        let sphereToRay = localRay.origin - Point(0, 0, 0)

        let a = localRay.direction • localRay.direction
        let b = 2 * (localRay.direction • sphereToRay)
        let c = (sphereToRay • sphereToRay) - 1

        let discriminant = (b * b) - (4 * a * c)

        if discriminant > 0 {
            let t1 = (-b - sqrt(discriminant)) / (2 * a)
            let t2 = (-b + sqrt(discriminant)) / (2 * a)

            let t1i = Intersection(distance: t1, shape: self)
            let t2i = Intersection(distance: t2, shape: self)

            return [t1i, t2i]
        } else if discriminant == 0 { // perfect tangent
            let t1 = (-b - sqrt(discriminant)) / (2 * a)
            let t1i = Intersection(distance: t1, shape: self)
            return [t1i, t1i]
        }

        return []
    }

	func localIntersects(_ ray: Ray) ->  [Intersection] {
		let localRay = ray.transform(transform.inverse)
		let sphereToRay = localRay.origin - Point(0, 0, 0)

		let a = localRay.direction • localRay.direction
		let b = 2 * (localRay.direction • sphereToRay)
		let c = (sphereToRay • sphereToRay) - 1

		let discriminant = (b * b) - (4 * a * c)

		if discriminant > 0 {
			let t1 = (-b - sqrt(discriminant)) / (2 * a)
			let t2 = (-b + sqrt(discriminant)) / (2 * a)

			let t1i = Intersection(distance: t1, shape: self)
			let t2i = Intersection(distance: t2, shape: self)

			return [t1i, t2i]
		} else if discriminant == 0 { // perfect tangent
			let t1 = (-b - sqrt(discriminant)) / (2 * a)
			let t1i = Intersection(distance: t1, shape: self)
			return [t1i, t1i]
		}

		return []
	}

	func normal(at worldPoint: Point) -> Vector {
		let objectPoint = transform.inverse * worldPoint
		let objectNormal = objectPoint - Point(0, 0, 0)
		let worldNormal = transform.inverse.transpose() * objectNormal
		worldNormal.w = 0
		return worldNormal.normalize()
	}

    static func == (lhs: Sphere, rhs: Sphere) -> Bool {
        return lhs.id == rhs.id
    }

	var description: String {
		return("Sphere: origin x: \(origin.x), y: \(origin.y), z: \(origin.z), radius x: \(radius), transform matrix: \((transform))")
	}
}
