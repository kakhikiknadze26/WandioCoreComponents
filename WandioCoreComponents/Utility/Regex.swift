//
//  Regex.swift
//  WandioCore
//
//  Created by Kakhi Kiknadze on 9/27/20.
//

import Foundation

public class Regex {
    
    public static let Email = "([A-Z0-9a-z._%+-]{2,})+@([A-Za-z0-9.-]{2,})+\\.[A-Za-z]{2,4}"
    public static let MobileNumber = "^5[0-9]{8}"
    public static let MobileNumberTyping = "^[0-9]{0,9}"
    public static let Password = "((?=.*\\d)(?=.*[A-Z])(?=.*[a-z])\\w.{8,20}\\w)"
    public static let SmsCode = "^[0-9]{4}"
    public static let PersonalId = "^[0-9]{11}"
    public static let PersonalIdTyping = "^[0-9]{0,11}"
    public static let AnyValue = ".*"
    public static let Numbers = "[0-9]*"
    public static let Currency = "^[0-9]*(|\\.[0-9]{1,2})$"
    public static let CurrencyTyping = "^[0-9]*(|\\.[0-9]{0,2})$"
    public static let TPCurrencyTyping = "^((0|0([1-9][0-9]{0,3}))|([1-9]([0-9]{0,4})))(|\\.[0-9]{0,2})$"
    public static let FebruaryMonthDays = "^([1-9]{1}|1[0-9]|2[0-8])$"
    public static let CardMask = "[0-9]{4}"
    public static let CardMaskTyping = "[0-9]{0,4}"
    
}
