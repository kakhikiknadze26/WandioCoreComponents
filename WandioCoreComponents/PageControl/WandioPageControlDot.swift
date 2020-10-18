//
//  WandioPageControlDot.swift
//  WandioCoreComponents
//
//  Created by Kakhi Kiknadze on 10/16/20.
//

import UIKit

internal class WandioPageControlDot: UIView {

    internal var currentState: State = .deselected
    internal var selectedColor: UIColor = .darkGray { didSet { updateUI() } }
    internal var deselectedColor: UIColor = .lightGray { didSet { updateUI() } }
    internal var style: Style = .rounded { didSet { updateUI() } }
    
    /// Reference to previous textField.
    internal weak var previousPage: WandioPageControlDot?
    
    /// Reference to next textField.
    internal weak var nextPage: WandioPageControlDot?
    
    internal func updateState(_ state: State) {
        currentState = state
    }
    
    internal func updateUI() {
        switch currentState {
        case .deselected:
            backgroundColor = deselectedColor
        case .selected:
            backgroundColor = selectedColor
        }
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if style == .rounded {
            layer.cornerRadius = bounds.height/2
        }
    }

}

internal extension WandioPageControlDot {
    
    enum State {
        case selected, deselected
    }
    
    enum Style {
        case rounded, rect
    }
    
}
