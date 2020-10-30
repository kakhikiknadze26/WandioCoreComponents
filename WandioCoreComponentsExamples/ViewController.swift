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
    let loader = MyLoader()

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //LoaderView.shared = loader
    }

    @IBAction func buttonTap(_ sender: UIButton) {
        startLoader()
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.stopLoader()
        }
//        updateImage()
//        return
//        let vc = BottomSheetController()
//        vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: true, completion: nil)
    }
    
    private func updateImage() {
        imageView.setImage(from: url, placeholderImage: UIImage(systemName: "square.and.arrow.up.fill")) { error in
            guard let error = error else { return }
            print(error)
        }
    }
    
}

class MyLoader: LoaderView {
    
    let indicator = UIActivityIndicatorView(style: .large)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = UIColor.red.withAlphaComponent(0.5)
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
