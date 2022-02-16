//
//  AZPopControl.swift
//  AZNavigationController
//
//  Created by minkook yoo on 2022/02/16.
//

import Foundation
import UIKit


class AZPopControl: UIControl {
    
    //-----------------------------------------------------------------------------
    // MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private let imageWidth = 25.0
    private let imageHeight = 30.0
    
    private func setup() {
        
//        backgroundColor = .green
        
        
        let imageView = UIImageView()
        var images = [UIImage]()
        
        for i in 0..<20 {
            let name = "run" + String(format: "%02d", i)
            if let image = UIImage(named: name, in: defaultBundle, compatibleWith: nil) {
                images.append(image)
            }
        }
        
        imageView.image = images[0]
        imageView.animationImages = images
        
        imageView.frame = CGRect(x: (bounds.width - imageWidth)/2, y: bounds.height - imageHeight, width: imageWidth, height: imageHeight)
        imageView.animationDuration = 0.35
        imageView.animationRepeatCount = 0
        
        imageView.transform = CGAffineTransform.init(scaleX: -1.0, y: 1.0)
        imageView.startAnimating()
        
        addSubview(imageView)
    }
    
    
    // MARK: -
    private lazy var defaultBundle: Bundle? = {
        let bundle = Bundle(for: AZNavigationController.self)
        guard let url = bundle.url(forResource: "AZNavigationController", withExtension: "bundle") else {
            return bundle
        }
        return Bundle(url: url)
    }()
    
}
