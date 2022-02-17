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
    
    
    //-----------------------------------------------------------------------------
    // MARK: public
    public var didContinueTrackingBlock: (() -> Void)?
    public var didEndTrackingNeedPopBlock: (() -> Void)?
    
    
    //-----------------------------------------------------------------------------
    // MARK: private
    private var startPoint: CGPoint?
    private var originFrame: CGRect = .zero
    
    private func setup() {
        let imageView = UIImageView()
        var images = [UIImage]()
        
        for i in 0..<20 {
            let name = "run" + String(format: "%02d", i)
            if let image = UIImage(named: name, in: AZConfig.ImageDefaultBundle, compatibleWith: nil) {
                images.append(image)
            }
        }
        
        imageView.image = images[0]
        imageView.animationImages = images
        
        let x = (bounds.width - AZConfig.PopControlItem_ImageWidth) / 2
        let y = bounds.height - AZConfig.PopControlItem_ImageHeight
        imageView.frame = CGRect(x: x, y: y, width: AZConfig.PopControlItem_ImageWidth, height: AZConfig.PopControlItem_ImageHeight)
        imageView.animationDuration = 0.35
        imageView.animationRepeatCount = 0
        
        imageView.transform = CGAffineTransform.init(scaleX: -1.0, y: 1.0)
        imageView.startAnimating()
        
        addSubview(imageView)
        
        addSubview(underlineView)
    }
    
    private lazy var underlineView: UIView = {
        let y = bounds.maxY - (AZConfig.PopControlUnderline_Height / 2)
        let underline = UIView(frame: CGRect(x: 0, y: y, width: 0, height: AZConfig.PopControlUnderline_Height))
        underline.backgroundColor = .red
        return underline
    }()
    
}



//-----------------------------------------------------------------------------
// MARK: -
extension AZPopControl {
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        startPoint = touch.location(in: superview)
        if originFrame == .zero {
            originFrame = frame
        }
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        guard let spt = startPoint else { return true }
        
        let pt = touch.location(in: superview)
        
        let vector = CGVector(dx: pt.x - spt.x, dy: pt.y - spt.y)
        
        if vector.dx > 0 {
            frame.origin.x = originFrame.origin.x + vector.dx
            underlineView.frame.origin.x = (originFrame.width/2) - vector.dx
            underlineView.frame.size.width = vector.dx
        }
        
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        startPoint = nil
        
        let ratio = 0.5
        let total = UIScreen.main.bounds.width - originFrame.midX
        let limit = originFrame.midX + (total * ratio)
        
        if frame.midX > limit {
            let maxPosition = UIScreen.main.bounds.width + originFrame.width
            UIView.animate(withDuration: 0.4) {
                self.frame.origin.x = maxPosition
                self.underlineView.frame.origin.x = -(self.originFrame.width + total)
                self.underlineView.frame.size.width = total
            } completion: { isFinish in
                self.underlineView.frame.size.width = 0
                if let block = self.didEndTrackingNeedPopBlock {
                    block()
                }
            }
        } else {
            UIView.animate(withDuration: 0.4) {
                self.frame.origin.x = self.originFrame.origin.x
                self.underlineView.frame.origin.x = (self.originFrame.width/2)
                self.underlineView.frame.size.width = 0
            }
        }
    }
}
