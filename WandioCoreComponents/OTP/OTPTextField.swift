//
//  OTPTextField.swift
//  WandioCoreComponents
//
//  Created by Kakhi Kiknadze on 10/14/20.
//

import UIKit

public enum OTPTextFieldState {
    case normal, error
}

@IBDesignable
open class OTPTextField: RoundedShadowedTextField {
    
    public override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    /// Error color for textField.
    open var errorColor: UIColor = .red
    
    /// Reference to previous textField.
    open weak var previousTextField: OTPTextField?
    
    /// Reference to next textField.
    open weak var nextTextField: OTPTextField?
    
    /// Current state of textField. Default is `.normal`
    private var currentState: OTPTextFieldState = .normal
    
    public required override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        setup()
    }
    
    
    /// Updates state of textfield to `.normal` or `.error` and  changes UI.
    /// - Parameter state: Text field state. Can be `.normal` or `.error`
    open func updateState(_ state: OTPTextFieldState) {
        self.currentState = state
        backgroundLayerStrokeColor = state == .error ? errorColor : .clear
        backgroundLayerLineWidth = state == .error ? 2 * screenFactor : .zero
    }
    
    private func setup() {
        keyboardType = .numberPad
        if #available(iOS 12.0, *) {
            textContentType = .oneTimeCode
        }
        backgroundColor = .clear
        textAlignment = .center
    }

}

public extension OTPTextField {
    
    override func deleteBackward() {
        text = ""
        previousTextField?.becomeFirstResponder()
    }
    
}

