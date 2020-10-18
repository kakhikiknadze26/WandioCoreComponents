//
//  ViewController.swift
//  WandioCoreComponentsExamples
//
//  Created by Kakhi Kiknadze on 10/13/20.
//

import UIKit
import WandioCoreComponents

class ViewController: UIViewController {

    @IBOutlet weak var pageControl: WandioPageControl!
    @IBOutlet weak var pageControl2: WandioPageControl!
    var incr = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.style = .shapeSlide
    }

    @IBAction func tapButton(_ sender: UIButton) {
        if pageControl.currentPage == max(0, pageControl.numberOfPages - 1) {
            incr *= -1
        } else if pageControl.currentPage == 0 && incr != 1 {
            incr *= -1
        }
        pageControl.select(pageControl.currentPage + incr)
        pageControl2.select(pageControl2.currentPage + incr)
    }
    
}

