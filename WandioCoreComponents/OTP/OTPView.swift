//
//  OTPView.swift
//  WandioCoreComponents
//
//  Created by Kakhi Kiknadze on 10/14/20.
//

import UIKit

@IBDesignable
open class OTPView: RoundedShadowedView {
    
    public override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    open override var backgroundColor: UIColor? {
        get { backgroundLayerColor }
        set { backgroundLayerColor = newValue ?? backgroundLayerColor }
    }
    
    /// Array of text fields
    open var textFields: [OTPTextField] = []
    
    /// OTPView delegate
    open weak var delegate: OTPViewDelegate? {
        didSet {
            reload()
        }
    }
    private var remainingStrStack: [String] = []
    private var numberOfFields = 4 {
        didSet {
            remakeFields()
        }
    }
    private var fieldType: OTPTextField.Type = OTPTextField.self
    private var fieldsSpacing: CGFloat = 20
    private var verticalSpacing: CGFloat = 40
    private var horizontalSpacing: CGFloat = 40
    
    /// Number of text fields in OTP View. Default is `4`
    @IBInspectable open var fieldCount: Int { get { numberOfFields } set { numberOfFields = newValue } }
    
    /// Spacing between text fields. Default is `20`
    @IBInspectable open var spacing: Float { get { Float(fieldsSpacing) } set { fieldsSpacing = CGFloat(newValue) } }
    
    /// Vertical padding of text fields. Default is `40`. Top and bottom paddings are half the `verticalPadding`
    @IBInspectable open var verticalPadding: Float { get { Float(verticalSpacing) } set { verticalSpacing = CGFloat(newValue) } }
    
    /// Horizontal padding of content. Default is `40`. Leading padding of first text field and trailing padding of last text field are half the `horizontalPadding`
    @IBInspectable open var horizontalPadding: Float { get { Float(horizontalSpacing) } set { horizontalSpacing = CGFloat(newValue) } }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    /// Register custom OTPTextfield type
    open func register<T>(_ type: T.Type) where T: OTPTextField {
        fieldType = type.self
        remakeFields()
    }
    
    private func initialize() {
        remakeFields()
    }
    
    /// Removes all text fields and remakes new ones.
    open func remakeFields() {
        for field in textFields {
            field.removeFromSuperview()
        }
        textFields.removeAll()
        addOTPFields()
    }
    
    private func addOTPFields() {
        for index in 0..<fieldCount {
            let field = fieldType.init(frame: .zero)
            //Adding a marker to previous field
            index != 0 ? (field.previousTextField = textFields[index-1]) : (field.previousTextField = nil)
            //Adding a marker to next field for the field at index-1
            index != 0 ? (textFields[index-1].nextTextField = field) : ()
            textFields.append(field)
            addSubview(field)
            delegate?.otpView(self, textField: field, at: index)
            field.delegate = self
            field.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    /// Reloads view. Delegate methods get called.
    open func reload() {
        for (index, field) in textFields.enumerated() {
            delegate?.otpView(self, textField: field, at: index)
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        for (index, field) in textFields.enumerated() {
            field.frame.size.height = frame.size.height - verticalSpacing
            field.frame.size.width = ((frame.size.width - horizontalSpacing) - fieldsSpacing * CGFloat(max(0, textFields.count - 1))) / CGFloat(textFields.count)
            field.frame.origin.y = (frame.size.height - field.frame.size.height)/2
            if index == 0 {
                field.frame.origin.x = horizontalSpacing/2
            } else if let prevField = field.previousTextField {
                field.frame.origin.x = prevField.frame.maxX + fieldsSpacing
            }
        }
    }
    
    private func checkForValidity() {
        for fields in textFields {
            if (fields.text == "") {
                delegate?.otpView(self, didChangeValidity: false, otp: getOTP())
                return
            }
        }
        delegate?.otpView(self, didChangeValidity: true, otp: getOTP())
    }
    
    /// Returns current OTP string.
    open func getOTP() -> String {
        var OTP = ""
        for textField in textFields {
            OTP += textField.text ?? ""
        }
        return OTP
    }
    
    
    /// Updates state of all textfields to `.normal` or `.error` and  changes UI.
    /// - Parameter state: Text field state. Can be `.normal` or `.error`
    open func updateState(_ state: OTPTextFieldState) {
        for textField in textFields {
            textField.updateState(state)
        }
    }
    
    private func autoFillTextField(with string: String) {
        remainingStrStack = string.reversed().compactMap{String($0)}
        for textField in textFields {
            if let charToAdd = remainingStrStack.popLast() {
                textField.text = String(charToAdd)
            } else {
                break
            }
        }
        checkForValidity()
        remainingStrStack = []
    }
    
    /// First text field becomes first responder
    open func showKeyboard() {
        textFields.first?.becomeFirstResponder()
    }
    
    /// Hides keyboard
    open func hideKeyboard() {
        endEditing(true)
    }
    
    /// Clears OTP value
    open func reset() {
        for field in textFields {
            field.text = nil
        }
    }
    
}

//MARK: - TextField Handling
extension OTPView: UITextFieldDelegate {
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        checkForValidity()
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textField = textField as? OTPTextField, !string.isEmpty else { return true }
        if string.count > 1 {
            textField.resignFirstResponder()
            autoFillTextField(with: string)
            return false
        } else {
            if (range.length == 0){
                textField.text? = string
                if textField.nextTextField == nil {
                    textField.resignFirstResponder()
                } else {
                    textField.nextTextField?.becomeFirstResponder()
                }
                return false
            }
            return true
        }
    }
    
}
