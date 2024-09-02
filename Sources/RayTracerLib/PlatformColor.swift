//
//  PlatformColor.swift
//
//
//  Created by Deirdre Saoirse Moen on 2/23/24.
//

import Foundation
#if os(macOS)
import AppKit

typealias PlatformColor = NSColor
#else
import UIKit

typealias PlatformColor = UIColor

extension UIColor {
	var redComponent: CGFloat {
		var red: CGFloat = 0.0
		var green: CGFloat = 0.0
		var blue: CGFloat = 0.0
		var alpha: CGFloat = 0.0

		getRed(&red, green: &green, blue: &blue, alpha: &alpha)
		return red
	}
}

#endif

extension PlatformColor {
	func normalized(_ value: CGFloat) -> CGFloat {
		return value / 255.0
	}
}
