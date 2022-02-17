//
//  AZPopControlManager.swift
//  AZNavigationController
//
//  Created by minkook yoo on 2022/02/17.
//

import Foundation

class AZPopControlManager {
    
    // MARK: - public
    public var navigationBarFrame: CGRect = .zero
    
    public var count: Int {
        get { return self.controls.count }
    }
    
    public func newPopControl(animated: Bool) -> AZPopControl {
        let control = createPopControl()
        let index = controls.count - 1
        adjustPosition(control, index: index, animated: animated)
        return control
    }
    
    public func positionPopControl(_ index: Int) -> CGFloat {
        return navigationBarFrame.origin.x + backItemWidth + ((itemWidth + itemSpacing) * CGFloat(index))
    }
    
    public func deletePopControls(_ index: Int, animated: Bool) {
        return removePopContols(index, animated: animated)
    }
    
    public var didEndTrackingNeedPopBlock: ((_ index: Int) -> Void)?
    
    
    // MARK: - private
    private let itemWidth = 44.0
    private let backItemWidth = 44.0
    private let itemSpacing = 0.0//10.0
    private var controls: Array = [AZPopControl]()
    
}


extension AZPopControlManager {
    
    private func createPopControl() -> AZPopControl {
        var frame = navigationBarFrame
        frame.size.width = itemWidth
        
        let control = AZPopControl(frame: frame)
        controls.append(control)
        
        control.didEndTrackingNeedPopBlock = {
            guard let index = self.controls.firstIndex(of: control) else { return }
            if let block = self.didEndTrackingNeedPopBlock {
                block(index)
            }
        }
        
        return control
    }
    
    private func adjustPosition(_ control: AZPopControl, index: Int, animated: Bool) {
        if animated {
            control.frame.origin.x = positionPopControl(index - 1)
            UIView.animate(withDuration: UINavigationControllerHideShowBarDuration) {
                control.frame.origin.x = self.positionPopControl(index)
            }
        } else {
            control.frame.origin.x = positionPopControl(index)
        }
    }
}


extension AZPopControlManager {
    
    private func removePopContols(_ index: Int, animated: Bool) {
        
        let removeControls = controls[index...]
            
        if animated {

            UIView.animate(withDuration: UINavigationControllerHideShowBarDuration) {
                for control in removeControls {
                    control.frame.origin.x = self.navigationBarFrame.maxX
                }
            } completion: { isFinish in
                for control in removeControls {
                    control.removeFromSuperview()
                }
                self.controls.removeSubrange(index...)
            }

        } else {
            for control in removeControls {
                control.removeFromSuperview()
            }
            self.controls.removeSubrange(index...)
        }
        
    }
    
}
