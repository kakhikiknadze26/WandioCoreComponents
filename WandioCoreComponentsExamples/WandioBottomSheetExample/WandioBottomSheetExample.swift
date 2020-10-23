//
//  WandioBottomSheetExample.swift
//  WandioCoreComponentsExamples
//
//  Created by Kakhi Kiknadze on 10/23/20.
//

import UIKit
import WandioCoreComponents

class BottomSheetContent: UIView {
    
    let child = UIView()
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(child)
        child.backgroundColor = .clear
        child.translatesAutoresizingMaskIntoConstraints = false
        child.heightAnchor.constraint(equalToConstant: 360).isActive = true
        child.topAnchor.constraint(equalTo: topAnchor).isActive = true
        child.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        child.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        child.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        label.text = "Content"
        label.translatesAutoresizingMaskIntoConstraints = false
        child.addSubview(label)
        label.centerXAnchor.constraint(equalTo: child.centerXAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: child.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}

class CustomBottomSheet: WandioBottomSheet {
    
    private let handler = WandioBottomSheetHandlerView()
    private let content = BottomSheetContent()
    
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
        addContent(content)
        handler.shadowColor = .black
        handler.shadowAlpha = 0.2
        handler.shadowRadius = 10 * screenFactor
        handler.shadowOffset = CGSize(width: 0, height: -10 * screenFactor)
        handler.roundingCorners = [.topLeft, .topRight]
        handler.cornerRadius = 20 * screenFactor
    }
    
}

class BottomSheetController: UIViewController {
    
    let btnDefault = UIButton()
    let btnCustom = UIButton()
    let stack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        btnDefault.setTitle("Present Default Bottom Sheet", for: .normal)
        btnDefault.addTarget(self, action: #selector(self.presentDefaultWandioBottomSheet), for: .touchUpInside)
        btnCustom.setTitle("Present Custom Bottom Sheet", for: .normal)
        btnCustom.addTarget(self, action: #selector(self.presentCustomBottomSheet), for: .touchUpInside)
        stack.axis = .vertical
        stack.addArrangedSubview(btnDefault)
        stack.addArrangedSubview(btnCustom)
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stack.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    @objc private func presentDefaultWandioBottomSheet() {
        DefaultWandioBottomSheet().present(on: self)
    }
    
    @objc private func presentCustomBottomSheet() {
        CustomBottomSheet().present(on: self)
    }
    
}
