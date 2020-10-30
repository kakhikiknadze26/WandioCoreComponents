//
//  RoundedShadowedTextField.swift
//  WandioCoreComponents
//
//  Created by Kakhi Kiknadze on 10/14/20.
//

import UIKit

/// Use this class to create shadowed view with corner radius on both the view and the shadow.
@IBDesignable
open class RoundedShadowedTextField: UITextField {
    
    public override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    open override var backgroundColor: UIColor? {
        get { backgroundLayerColor }
        set { backgroundLayerColor = newValue ?? .white }
    }
    
    private var shadowLayer = CAShapeLayer()
    private lazy var backgroundLayer = configure(CAShapeLayer()) { $0.fillColor = UIColor.white.cgColor }
    
    /// Color of view's first layer. Default is `UIColor.white`
    internal var backgroundLayerColor: UIColor = .white { didSet { backgroundLayer.fillColor = backgroundLayerColor.cgColor } }
    /// Stroke color of view's first layer. Default is `UIColor.white`
    @IBInspectable open var strokeColor: UIColor = .white { didSet{ backgroundLayer.strokeColor = strokeColor.cgColor } }
    /// Line width of view's first layer. Default is `0`
    @IBInspectable open var lineWidth: CGFloat = .zero { didSet { backgroundLayer.lineWidth = lineWidth } }
    /// Color of shadow. Default is `.black`
    @IBInspectable open var shadowColor: UIColor = .black { didSet { shadowLayer.shadowColor = shadowColor.cgColor } }
    /// Opacity of shadow. Default is `1.0`
    @IBInspectable open var shadowAlpha: Float = 1.0 { didSet { shadowLayer.shadowOpacity = shadowAlpha } }
    /// Offset of shadow. Default is `(0, -3.0)`
    @IBInspectable open var shadowOffset: CGSize = CGSize(width: .zero, height: -3.0) { didSet { shadowLayer.shadowOffset = shadowOffset } }
    /// Radius of shadow. Default is `3.0`
    @IBInspectable open var shadowRadius: CGFloat = 3.0 { didSet { shadowLayer.shadowRadius = shadowRadius } }
    /// Radius of corner. Default is `0`
    @IBInspectable open var cornerRadius: CGFloat = .zero { didSet { setNeedsLayout(); layoutIfNeeded() } }
    /// Adjusts shadow offset to fit device's screen by multiplying it on screen factor.
    /// - Warning: You must set screen factor first. E.g. when the app finishes launching.
    /// ```
    /// screenFactor = UIScreen.main.bounds.size.width/414
    /// ```
    @IBInspectable open var adjustShadowOffsetToFitDevice: Bool { get { false } set { if(newValue) { fitShadowOffsetToDevice() } } }
    /// Adjusts shadow radius to fit device's screen by multiplying it on screen factor
    /// - Warning: You must set screen factor first. E.g. when the app finishes launching.
    /// ```
    /// screenFactor = UIScreen.main.bounds.size.width/414
    /// ```
    @IBInspectable open var adjustShadowRadiusToFitDevice: Bool { get { false } set { if(newValue) { fitShadowRadiusToDevice() } } }
    /// Adjusts corner radius to fit device's screen by multiplying it on screen factor
    /// - Warning: You must set screen factor first. E.g. when the app finishes launching.
    /// ```
    /// screenFactor = UIScreen.main.bounds.size.width/414
    /// ```
    @IBInspectable open var adjustCornerRadiusToFitDevice: Bool { get { false } set { if(newValue) { fitCornerRadiusToDevice() } } }
    /// Adjusts background layer's line width to fit device's screen by multiplying it on screen factor
    /// - Warning: You must set screen factor first. E.g. when the app finishes launching.
    /// ```
    /// screenFactor = UIScreen.main.bounds.size.width/414
    /// ```
    @IBInspectable open var adjustLineWidthToFitDevice: Bool { get { false } set { if(newValue) { fitLineWidthToDevice() } } }
    /// Corners available to round. Default is `.allCorners`
    open var roundingCorners: UIRectCorner = .allCorners { didSet { setNeedsLayout(); layoutIfNeeded() } }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        backgroundColor = .clear
        addShadowAndBackground()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        superview?.layoutIfNeeded()
        setPaths()
    }
     
    private func addShadowAndBackground() {
        layer.insertSublayer(shadowLayer, at: 0)
        layer.insertSublayer(backgroundLayer, at: 1)
    }
    
    open func updateLayers() {
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowOpacity = shadowAlpha
        shadowLayer.shadowOffset = shadowOffset
        shadowLayer.shadowRadius = shadowRadius
        backgroundLayer.fillColor = backgroundLayerColor.cgColor
    }

    private func setPaths() {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        shadowLayer.shadowPath = path.cgPath
        backgroundLayer.path = path.cgPath
    }
    
}

public extension RoundedShadowedTextField {
    
    func fitShadowOffsetToDevice() {
        shadowOffset = CGSize(width: shadowOffset.width * screenFactor, height: shadowOffset.height * screenFactor)
    }
    
    func fitShadowRadiusToDevice() {
        shadowRadius *= screenFactor
    }
    
    func fitCornerRadiusToDevice() {
        cornerRadius *= screenFactor
    }
    
    func fitLineWidthToDevice() {
        backgroundLayer.lineWidth *= screenFactor
    }
    
}

