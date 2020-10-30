//
//  LoaderExtensions.swift
//  WandioCoreComponents
//
//  Created by Kakhi Kiknadze on 10/30/20.
//

import UIKit

public extension UIView {
    
    /// Present and start your custom loader or loader assigned on `LoaderView`'s shared instance
    func startLoader(_ loader: LoaderView? = nil) {
        let loader = (loader ?? LoaderView.shared)
        guard !loader.isLoading else { return }
        endEditing(true)
        addSubview(loader)
        loader.stretchLayout()
        loader.start()
    }
    
    /// Stop and remove your custom loader or loader assigned on `LoaderView`'s shared instance
    func stopLoader(_ loader: LoaderView? = nil) {
        let loader = (loader ?? LoaderView.shared)
        guard loader.isLoading else { return }
        loader.stop()
        loader.removeFromSuperview()
    }
    
}

public extension UIViewController {
    
    /// Present and start your custom loader or loader assigned on `LoaderView`'s shared instance
    func startLoader(_ loader: LoaderView? = nil) {
        view.startLoader(loader)
    }
    
    /// Stop and remove your custom loader or loader assigned on `LoaderView`'s shared instance
    func stopLoader(_ loader: LoaderView? = nil) {
        view.stopLoader(loader)
    }
    
}
