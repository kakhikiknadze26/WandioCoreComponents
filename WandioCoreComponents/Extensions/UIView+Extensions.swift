//
//  UIView+Extensions.swift
//  WandioCoreComponents
//
//  Created by Kakhi Kiknadze on 10/23/20.
//

import UIKit

extension UIView {
    
    internal func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        layoutIfNeeded()
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    internal func stretchLayout() {
        guard let sv = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: sv.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: sv.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: sv.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: sv.bottomAnchor).isActive = true
    }
    
}
