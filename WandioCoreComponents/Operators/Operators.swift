//
//  Operators.swift
//  WandioCoreComponents
//
//  Created by Kakhi Kiknadze on 10/15/20.
//

import Foundation

infix operator =|

func =|<T: Equatable>(lhs: T, rhs: [T]) -> Bool {
    rhs.contains(where: {lhs == $0})
}
