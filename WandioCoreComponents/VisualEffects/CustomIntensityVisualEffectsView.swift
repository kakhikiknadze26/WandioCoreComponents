//
//  CustomIntensityVisualEffectsView.swift
//  WandioCore
//
//  Created by Kakhi Kiknadze on 9/27/20.
//

import UIKit

/// Visual Effect View with custom intensity value.
public class CustomIntensityVisualEffectView: UIVisualEffectView {
    
    private var animator: UIViewPropertyAnimator?
    
    /// Visual Effect View with custom intensity value.
    /// - Parameters:
    ///     - effect: Visual Effect
    ///     - intensity: Intensity of the provided visual effect
    public init(effect: UIVisualEffect, intensity: CGFloat) {
        super.init(effect: nil)
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear, animations: {
            self.effect = effect
        })
        animator?.fractionComplete = intensity
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

