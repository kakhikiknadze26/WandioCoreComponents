//
//  UtilityFunctions.swift
//  KKUIComponents
//
//  Created by Kakhi Kiknadze on 9/20/20.
//

import UIKit

/// Takes the initialized object, passes it to closure for mutation and returns mutated result.
/// # Code
/// ```
/// let view = configure(UIView()) {
///     $0.backgroundColor = .orange
/// }
/// ```
/// or lazily
/// ```
/// lazy var view = configure(UIView()) {
///     $0.backgroundColor = .orange
/// }
/// ```
/// - Parameters:
///     - value: Initialized object.
///     - closure: closure where modifications on value happens.
/// - Returns: mutated version of input value
///
public func configure<T>(_ value: T, using closure: (inout T) throws -> Void) rethrows -> T {
    var value = value
    try closure(&value)
    return value
}

/// Returns color depending on user interface style
public func colorPair(light: UIColor, dark: UIColor) -> UIColor {
    return UIColor { traitCollecion -> UIColor in
        switch traitCollecion.userInterfaceStyle {
        case .dark:
            return dark
        case .light, .unspecified:
            return light
        @unknown default:
            return light
        }
    }
}
