//
//  WandioBottomSheetDelegate.swift
//  WandioCoreComponents
//
//  Created by Kakhi Kiknadze on 10/21/20.
//

import UIKit

public protocol WandioBottomSheetDelegate: class {
    
    /// Tells the delegate that bottom sheet pan gesture began
    /// - Parameters:
    ///   - sheet: Bottom sheet
    ///   - recognizer: Pan gesture recognizer
    func bottomSheet(_ sheet: WandioBottomSheet, didBeginPanGesture recognizer: UIPanGestureRecognizer)
    
    /// Tells the delegate that bottom sheet pan gesture changed
    /// - Parameters:
    ///   - sheet: Bottom sheet
    ///   - recognizer: Pan gesture recognizer
    func bottomSheet(_ sheet: WandioBottomSheet, didChangePanGesture recognizer: UIPanGestureRecognizer)
    
    
    /// Tells the delegate that bottom sheet pan gesture ended
    /// - Parameters:
    ///   - sheet: Bottom sheet
    ///   - recognizer: Pan gesture recoginzier
    func bottomSheet(_ sheet: WandioBottomSheet, didEndPanGesture recognizer: UIPanGestureRecognizer)
    
}

extension WandioBottomSheetDelegate {
    
    public func bottomSheet(_ sheet: WandioBottomSheet, didBeginPanGesture recognizer: UIPanGestureRecognizer) {}
    
    public func bottomSheet(_ sheet: WandioBottomSheet, didChangePanGesture recognizer: UIPanGestureRecognizer) {}
    
    public func bottomSheet(_ sheet: WandioBottomSheet, didEndPanGesture recognizer: UIPanGestureRecognizer) {}
    
}
