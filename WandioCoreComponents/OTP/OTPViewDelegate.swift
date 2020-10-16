//
//  OTPViewDelegate.swift
//  WandioCoreComponents
//
//  Created by Kakhi Kiknadze on 10/15/20.
//

import Foundation

public protocol OTPViewDelegate: class {
    
    /// Tells if all text fields are filled
    /// - Parameters:
    ///   - view: OTP View
    ///   - isValid: Indicates wether all text fields are filled
    ///   - otp: Current OTP value
    func otpView(_ view: OTPView, didChangeValidity isValid: Bool, otp: String)
    
    
    /// Returns text field at corresponding index
    /// - Parameters:
    ///   - view: OTP View
    ///   - field: Text field
    ///   - index: Index of text field
    func otpView(_ view: OTPView, textField field: OTPTextField, at index: Int)
    
}
