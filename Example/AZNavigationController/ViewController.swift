//
//  ViewController.swift
//  AZNavigationController
//
//  Created by minkook on 02/16/2022.
//  Copyright (c) 2022 minkook. All rights reserved.
//

import UIKit
import AZNavigationController

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        AZConfig.shared.PopControlItem_LimitCount = 3
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}


// MARK: Button Action
extension ViewController {
    
    @IBAction func testButtonAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChildViewController")
        let nc = AZNavigationController(rootViewController: vc)
        self.present(nc, animated: true, completion: nil)
    }
    
}

