//
//  ViewController.swift
//  WandioCoreComponentsExamples
//
//  Created by Kakhi Kiknadze on 10/13/20.
//

import UIKit
import WandioCoreComponents

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func buttonTap(_ sender: UIButton) {
        let vc = BottomSheetController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
}
