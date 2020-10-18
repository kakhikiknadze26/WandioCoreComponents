//
//  WandioPageControl.swift
//  WandioCoreComponents
//
//  Created by Kakhi Kiknadze on 10/16/20.
//

import UIKit

open class WandioPageControl: UIControl {
    
    // MARK: - Properties
    /// default is 0
    open var numberOfPages: Int = 4 { didSet { createPages() } }
    
    /// default is 0.
    open var currentPage: Int = 0
    
    /// hides the indicator if there is only one page, default is NO
    open var hidesForSinglePage: Bool = false

    /// The tint color for non-selected indicators. Default is nil.
    open var pageIndicatorTintColor: UIColor?

    /// The tint color for the currently-selected indicators. Default is nil.
    open var currentPageIndicatorTintColor: UIColor?
    
    /// Size of indicators
    open var indicatorSize: CGSize = CGSize(width: 8, height: 8)
    
    /// Spacing between indicators. Default is 8.
    open var spacing: CGFloat = 8
    
    /// Animation type
    open var style: Style = .bouncedSwitch { didSet { setupStyle() } }
    
    internal let defaultAnimationDuration: TimeInterval = 0.4
    internal let defaultIndicatorColor: UIColor = .lightGray
    internal let defaultCurrentIndicatorColor: UIColor = .darkGray
    internal var pages: [WandioPageControlDot] = []
    internal var shapeLayer = CAShapeLayer()

    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        createPages()
        setupShapeLayer()
        setupStyle()
    }
    
    private func setupStyle() {
        switch style {
        case .bouncedSwitch:
            showShapeLayer(false)
            ignoreSelectedColorOnPages(false)
        case .shapeSlide:
            showShapeLayer()
            ignoreSelectedColorOnPages()
        }
    }
    
    // MARK: - Lifecycle
    open override func layoutSubviews() {
        super.layoutSubviews()
        layoutPages()
        layoutShapeLayerIfNeeded()
    }
    
    private func layoutShapeLayerIfNeeded() {
        guard shapeLayer.isHidden == false else { return }
        shapeLayer.removeAllAnimations()
        changeShape()
    }
    
    private func layoutPages() {
        for (index, page) in pages.enumerated() {
            page.frame.size = indicatorSize
            setupOriginForPage(page, at: index)
        }
    }
    
    // MARK: - Layout
    private func setupOriginForPage(_ page: WandioPageControlDot, at index: Int) {
        page.frame.origin.y = (bounds.height - page.bounds.height)/2
        if index == 0 {
            page.frame.origin.x = (bounds.width - size(forNumberOfPages: numberOfPages).width)/2
        } else if let prevPage = page.previousPage {
            page.frame.origin.x = prevPage.frame.maxX + spacing
        }
    }
    
    internal func createPages() {
        resetPages()
        if hidesForSinglePage && numberOfPages == 1 {
            return
        }
        for index in 0..<numberOfPages {
            let page = WandioPageControlDot()
            index != 0 ? (page.previousPage = pages[index-1]) : (page.previousPage = nil)
            index != 0 ? (pages[index-1].nextPage = page) : ()
            page.updateState(index == currentPage ? .selected : .deselected)
            page.deselectedColor = pageIndicatorTintColor ?? defaultIndicatorColor
            page.selectedColor = currentPageIndicatorTintColor ?? defaultCurrentIndicatorColor
            pages.append(page)
            addSubview(page)
        }
    }
    
    private func resetPages() {
        for page in pages {
            page.removeFromSuperview()
        }
        pages.removeAll()
    }
    
    /// Returns the minimum size required to display indicators for the given page count. Can be used to size the control if the page count could change.
    open func size(forNumberOfPages pageCount: Int) -> CGSize {
        let widthMult = indicatorSize.width * CGFloat(pageCount)
        let spacingMult = spacing * max(0, CGFloat(pageCount - 1))
        let width = widthMult + spacingMult
        let height = indicatorSize.height
        return CGSize(width: width, height: height)
    }
    
    // MARK: - Shape Layer
    internal func indicatorPath() -> UIBezierPath {
        let current = pages[currentPage]
        var rect = current.frame
        let halfWidth = rect.size.width/2
        rect.size.width += halfWidth
        rect.origin.x -= halfWidth/2
        current.layoutIfNeeded()
        let path = UIBezierPath(roundedRect: rect, cornerRadius: current.layer.cornerRadius)
        return path
    }
    
    internal func changeShape() {
        guard !pages.isEmpty else { return }
        shapeLayer.path = indicatorPath().cgPath
    }
    
    internal func setupShapeLayer() {
        layer.addSublayer(shapeLayer)
        shapeLayer.fillColor = currentPageIndicatorTintColor?.cgColor ?? defaultCurrentIndicatorColor.cgColor
    }
    
    internal func showShapeLayer(_ show: Bool = true) {
        shapeLayer.isHidden = !show
    }
    
    // MARK: - Actions
    open func select(_ index: Int) {
        guard !pages.isEmpty, 0..<pages.count ~= index else { return }
        animate(selection: index)
    }
    
    internal func animate(selection index: Int) {
        switch style {
        case .bouncedSwitch:
            switchAnimation(selectionIndex: index)
        case .shapeSlide:
            animateShape(selectionIndex: index)
        }
    }
    
    internal func ignoreSelectedColorOnPages(_ ignore: Bool = true) {
        let deselectedColor = pageIndicatorTintColor ?? defaultIndicatorColor
        let selectedColor = currentPageIndicatorTintColor ?? defaultCurrentIndicatorColor
        for page in pages {
            page.selectedColor = ignore ? deselectedColor : selectedColor
        }
    }

}

extension WandioPageControl {
    
    public enum Style {
        case bouncedSwitch
        case shapeSlide
    }
    
}

// MARK: - Animations
extension WandioPageControl: CAAnimationDelegate {
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            changeShape()
        }
    }
    
    private func switchAnimation(selectionIndex index: Int, duration: TimeInterval = 0.4) {
        let newSelection = pages[index]
        let currentSelection = pages[currentPage]
        let currentOrigin = pages[currentPage].frame.origin
        let newOrigin = newSelection.frame.origin
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: .curveEaseInOut) {
            newSelection.frame.origin.x = currentOrigin.x
            currentSelection.frame.origin.x = newOrigin.x
        } completion: { _ in
            let prevSelection = self.pages.remove(at: self.currentPage)
            self.pages.insert(prevSelection, at: index)
            self.currentPage = index
        }
    }
    
    private func animateShape(selectionIndex index: Int, duration: TimeInterval = 0.4) {
        pages[currentPage].updateState(.deselected)
        pages[index].updateState(.selected)
        let currentShape = indicatorPath()
        currentPage = index
        let newShapePath = indicatorPath()
        let animation = CABasicAnimation(keyPath: #keyPath(CAShapeLayer.path))
        animation.duration = duration
        animation.fromValue = currentShape
        animation.toValue = newShapePath.cgPath
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.delegate = self
        shapeLayer.add(animation, forKey: "path")
    }
    
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct TrakiPreview: PreviewProvider {
    static var devices: [PreviewDevices] = [.iPhone11]

    static var previews: some View {
        ForEach(devices.map{$0.string}, id: \.self) { deviceName in
            WandioPageControl().toPreview().previewLayout(PreviewLayout.fixed(width: 200, height: 50))
                .previewDisplayName(String(describing: WandioPageControl.self))
        }
    }
}

#endif
