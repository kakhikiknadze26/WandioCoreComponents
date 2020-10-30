//
//  LoaderView.swift
//  WandioCoreComponents
//
//  Created by Kakhi Kiknadze on 10/30/20.
//

import UIKit

open class LoaderView: UIView {
    
    open var isLoading: Bool = false
    
    public static var shared: LoaderView = DefaultLoader()
    
    /// Start loading
    open func start() {
        isLoading = true
    }
    
    /// Stop loading
    open func stop() {
        isLoading = false
    }
    
}

internal class DefaultLoader: LoaderView {
    
    let indicator = UIActivityIndicatorView(style: .large)
    
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    internal required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    internal func setup() {
        backgroundColor = UIColor.white.withAlphaComponent(0.5)
        addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        indicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    override func start() {
        super.start()
        indicator.startAnimating()
    }
    
    override func stop() {
        super.stop()
        indicator.stopAnimating()
    }
    
}
