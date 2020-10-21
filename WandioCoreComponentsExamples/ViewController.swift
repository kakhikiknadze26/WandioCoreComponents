//
//  ViewController.swift
//  WandioCoreComponentsExamples
//
//  Created by Kakhi Kiknadze on 10/13/20.
//

import UIKit
import WandioCoreComponents

class TestView: UIView {
    
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
        //label.centerYAnchor.constraint(equalTo: child.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}

public class TestVC: UIViewController {
    
    let sheet = WandioBottomSheet()
    let button = UIButton(frame: CGRect(x: 40, y: 100, width: 100, height: 100))
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        button.setTitle("Press Me", for: .normal)
        button.addTarget(self, action: #selector(self.buttonTap), for: .touchUpInside)
        view.addSubview(button)
        view.backgroundColor = .orange
        let test = TestView()
        test.backgroundColor = .magenta
        sheet.addContent(test)
        
    }
    
    @objc private func buttonTap() {
        button.setTitle("\(Int.random(in: 0...10))", for: .normal)
        sheet.present(on: self, animated: true, completion: nil)
    }
    
}

class ViewController: UIViewController {
    
    let sheet = WandioBottomSheet()

    override func viewDidLoad() {
        super.viewDidLoad()
        let test = TestView()
        test.backgroundColor = .magenta
        sheet.addContent(test)
    }

    @IBAction func buttonTap(_ sender: UIButton) {
        sender.setTitle("\(Int.random(in: 0...10))", for: .normal)
        let test = TestView()
        test.backgroundColor = .magenta
        let sheet = WandioBottomSheet()
        sheet.addContent(test)
        sheet.present(on: self, animated: true, completion: nil)
    }
    
}

