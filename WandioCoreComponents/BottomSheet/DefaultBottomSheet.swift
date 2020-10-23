//
//  DefaultBottomSheet.swift
//  WandioCoreComponents
//
//  Created by Kakhi Kiknadze on 10/23/20.
//

import UIKit

/// Default bottom sheet by Wandio
public class DefaultWandioBottomSheet: WandioBottomSheet {
    
    private let handler = WandioBottomSheetHandlerView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        contentHeight = 300 * screenFactor
        addHandle(handler)
        handler.shadowColor = .black
        handler.shadowAlpha = 0.2
        handler.shadowRadius = 10 * screenFactor
        handler.shadowOffset = CGSize(width: 0, height: -10 * screenFactor)
        handler.roundingCorners = [.topLeft, .topRight]
        handler.cornerRadius = 20 * screenFactor
    }
    
}

/// Default Bottom sheet handler view by Wandio
public final class WandioBottomSheetHandlerView: RoundedShadowedView {
    
    let handler = UIView()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        backgroundColor = .white
        addHandler()
    }
    
    private func addHandler() {
        handler.backgroundColor = .lightGray
        addSubview(handler)
        handler.translatesAutoresizingMaskIntoConstraints = false
        handler.heightAnchor.constraint(equalToConstant: 8 * screenFactor).isActive = true
        handler.widthAnchor.constraint(equalToConstant: 80 * screenFactor).isActive = true
        handler.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        handler.topAnchor.constraint(equalTo: topAnchor, constant: 12 * screenFactor).isActive = true
        handler.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12 * screenFactor).isActive = true
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        handler.layoutIfNeeded()
        handler.layer.cornerRadius = handler.bounds.height/2
        handler.clipsToBounds = true
    }
    
}

#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct BottomSheetPreview: PreviewProvider {
    static var devices: [PreviewDevices] = [.iPhone8, .iPhone11ProMax]

    static var previews: some View {
        ForEach(devices.map{$0.string}, id: \.self) { deviceName in
            DefaultWandioBottomSheet().toPreview().edgesIgnoringSafeArea(.all).previewDevice(PreviewDevice(rawValue: deviceName))
            .previewDisplayName(deviceName)
        }
    }
}
#endif
