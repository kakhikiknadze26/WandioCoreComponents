//
//  ViewController.swift
//  WandioCoreComponentsExamples
//
//  Created by Kakhi Kiknadze on 10/13/20.
//

import UIKit
import WandioCoreComponents

class ViewController: UIViewController {
    
    let url = URL(string: "https://images.unsplash.com/photo-1556983990-db5d0cc3c67e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1275&q=80")!

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func buttonTap(_ sender: UIButton) {
        updateImage()
        return
        let vc = BottomSheetController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    private func updateImage() {
        imageView.setImage(from: url, placeholderImage: UIImage(systemName: "square.and.arrow.up.fill")) { error in
            guard let error = error else { return }
            print(error)
        }
    }
    
}
