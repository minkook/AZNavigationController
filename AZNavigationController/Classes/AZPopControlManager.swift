//
//  AZPopControlManager.swift
//  AZNavigationController
//
//  Created by minkook yoo on 2022/02/17.
//

import Foundation

class AZPopControlManager {
    
    
    //-----------------------------------------------------------------------------
    // MARK: public
    public var navigationBarFrame: CGRect = .zero
    
    
    // control count
    public var count: Int {
        get { return controls.count }
    }
    
    
    // underline
    public var underlineView: UIView {
        get { return _underlineView }
    }
    
    
    // new
    public func newPopControl(animated: Bool) -> AZPopControl {
        let control = createPopControl()
        let index = controls.count - 1
        adjustPosition(control, index: index, animated: animated)
        return control
    }
    
    
    // delete
    public func deletePopControls(_ index: Int, animated: Bool) {
        return removePopContols(index, animated: animated)
    }
    
    
    // control handler - need pop
    public var didEndTrackingNeedPopBlock: ((_ index: Int) -> Void)?
    
    
    //-----------------------------------------------------------------------------
    // MARK: private
    private var controls: Array = [AZPopControl]()
    
    private lazy var _underlineView: UIView = {
        let height = AZConfig.PopControlUnderline_Height
        var frame = navigationBarFrame
        frame.origin.y = frame.maxY - (height/2)
        frame.size.width = 0
        frame.size.height = height
        let underline = UIView(frame: frame)
        underline.backgroundColor = AZConfig.PopControlUnderline_Color
        return underline
    }()
    
}


//-----------------------------------------------------------------------------
// MARK: -
extension AZPopControlManager {
    
    private func positionPopControl(_ index: Int) -> CGFloat {
        var x = navigationBarFrame.origin.x
        x += AZConfig.NavigationBarBackItem_Width
        x += ((AZConfig.PopControlItem_Width + AZConfig.PopControlItem_Spacing) * CGFloat(index))
        return x
    }
    
    private func positionUnderline(_ index: Int) -> CGFloat {
        return positionPopControl(index) + (AZConfig.PopControlItem_Width / 2)
    }
}


extension AZPopControlManager {
    
    private func createPopControl() -> AZPopControl {
        var frame = navigationBarFrame
        frame.size.width = AZConfig.PopControlItem_Width
        
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
        
        let excute = {
            control.frame.origin.x = self.positionPopControl(index)
            self._underlineView.frame.size.width = self.positionUnderline(index)
        }
        
        if animated {
            control.frame.origin.x = positionPopControl(index - 1)
            UIView.animate(withDuration: UINavigationControllerHideShowBarDuration) {
                excute()
            }
        } else {
            excute()
        }
    }
}


extension AZPopControlManager {
    
    private func removePopContols(_ index: Int, animated: Bool) {
        
        let isFirst = index == 0
        let removeControls = controls[index...]
        
        let excute = {
            for control in removeControls {
                control.removeFromSuperview()
            }
            self.controls.removeSubrange(index...)
            if isFirst {
                self.underlineView.removeFromSuperview()
            }
        }
        
        if animated {
            UIView.animate(withDuration: UINavigationControllerHideShowBarDuration) {
                for control in removeControls {
                    control.frame.origin.x = self.navigationBarFrame.maxX
                }
                self.underlineView.frame.size.width = self.positionUnderline(index - 1)
            } completion: { isFinish in
                excute()
            }

        } else {
            self.underlineView.frame.size.width = positionUnderline(index - 1)
            excute()
        }
    }
}
