//
//  ChildViewController.swift
//  AZNavigationController_Example
//
//  Created by minkook yoo on 2022/02/16.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class ChildViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
    }
    
    func setUpView() {
        guard let nc = self.navigationController else { return }
        
        let count = nc.viewControllers.count
        
        if count == 1 {
            self.title = "Root"
        } else {
            self.title = "Page " + String(format: "%d", count - 1)
        }
    }
    
    @IBAction func pushButtonAction(_ sender: Any) {
        guard let nc = self.navigationController else { return }

        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChildViewController")
        nc.pushViewController(vc, animated: true)
    }
    
}
