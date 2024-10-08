//
//  Color.swift
//  RayTracer
//
//  Created by Deirdre Saoirse Moen on 3/5/19.
//  Copyright © 2019 Deirdre Saoirse Moen. All rights reserved.
//

#if canImport(AppKit)
import AppKit
#else
import UIKit
#endif

// swiftlint:disable identifier_name

class VColor: Vector {
	public static let white = VColor(1, 1, 1)
	public static let black = VColor(0, 0, 0)

	required init(_ x: CGFloat, _ y: CGFloat, _ z: CGFloat, _ w: CGFloat) {
		super.init(x, y, z, 0.0)
	}

    override init(_ x: CGFloat, _ y: CGFloat, _ z: CGFloat) {
        super.init(x, y, z)
    }

	convenience init(color: PlatformColor) {
		var red: CGFloat = 0.0
		var green: CGFloat = 0.0
		var blue: CGFloat = 0.0
		var alpha: CGFloat = 0.0

		color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

		self.init(red, green, blue)
	}
	
	required init(from decoder: any Decoder) throws {
		try super.init(from: decoder)
	}
		
	public var red: CGFloat {
		get {
			return CGFloat(x)
		}
		set(newRed) {
			self.x = newRed
		}
	}

	public var green: CGFloat {
		get {
			return CGFloat(y)
		}
		set(newGreen) {
			self.y = newGreen
		}
	}

	public var blue: CGFloat {
		get {
			return CGFloat(z)
		}
		set(newBlue) {
			self.z = newBlue
		}
	}

    // clamps a color to be in a valid range

	func clamped() -> VColor {

		let colors = [self.red, self.green, self.blue]
		var outcolors: [CGFloat] = [0.0, 0.0, 0.0] // TODO: I know there's a better way….

		for index in 0..<colors.count {
			if colors[index] > 1 {
				outcolors[index] = 1
			} else if colors[index] < 0 {
				outcolors[index] = 0
			} else {
				outcolors[index] = colors[index]
			}
		}
		return VColor(outcolors[0], outcolors[1], outcolors[2])
	}

	func color() -> PlatformColor {
		return PlatformColor(red: x, green: y, blue: z, alpha: 1.0)
	}

	override var description: String {
		return("Point: x: \(x), y: \(y), z: \(z), w: \(w)")
	}
}
