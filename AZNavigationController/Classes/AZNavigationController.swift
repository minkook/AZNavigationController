//
//  AZNavigationController.swift
//  AZNavigationController
//
//  Created by minkook yoo on 2022/02/16.
//

import Foundation
import UIKit

open class AZNavigationController: UINavigationController {
    
    //-----------------------------------------------------------------------------
    // MARK: init
    override public init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setup()
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    override public init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    private func setup() {
        modalPresentationStyle = .fullScreen
    }
    
    //-----------------------------------------------------------------------------
    // MARK: control
    private let itemLimitCount = 5
    private let backItemWidth = 44.0
    private let itemWidth = 44.0
    private let itemSpacing = 0.0//10.0
    
    private lazy var underline: UIView = {
        let height = 8.0
        var frame = navigationBar.frame
        frame.origin.y = frame.maxY - (height/2)
        frame.size.width = 0
        frame.size.height = height
        let underline = UIView(frame: frame)
        underline.backgroundColor = .black
        return underline
    }()
    
    private var popControls: Array = [AZPopControl]()
}


//-----------------------------------------------------------------------------
// MARK: - private
extension AZNavigationController {
    func createPopControl(_ index: Int) -> AZPopControl {
        var frame = navigationBar.frame
//        frame.origin.x = positionPopControl(index)
        frame.size.width = itemWidth
        return AZPopControl(frame: frame)
    }
    
    func positionPopControl(_ index: Int) -> CGFloat {
        return navigationBar.frame.origin.x + backItemWidth + ((itemWidth + itemSpacing) * CGFloat(index))
    }
    
    func positionUnderline(_ index: Int) -> CGFloat {
        return positionPopControl(index) + (itemWidth/2)
    }
}


//-----------------------------------------------------------------------------
// MARK: - push
extension AZNavigationController {
    
    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
//        viewController.navigationItem.hidesBackButton = true
        viewController.navigationItem.backButtonTitle = ""
        
        super.pushViewController(viewController, animated: animated)
        
        viewController.title = "가나다라마바사아"
        
        if animated {
            if let coordinator = transitionCoordinator {
                coordinator.animate(alongsideTransition: nil) { _ in
                    self.didPush(animated)
                }
            }
        }
        else {
            self.didPush(animated)
        }
        
    }
    
    private func validControl() -> Bool {
        let count = viewControllers.count
        if count == 1 || count > itemLimitCount + 1 {
            return false
        }
        return true
    }
    
    private func didPush(_ animated: Bool) {
        if !validControl() { return }
        
        let index = viewControllers.count - 2
        let isFirst = index == 0
        
        print("didPush: \(index)")
        
        if isFirst {
            view.addSubview(self.underline)
        }
        
        let popControl = createPopControl(index)
        view.addSubview(popControl)
        popControls.append(popControl)
        
        let underlineWidth = positionUnderline(index)
        if animated {
            popControl.frame.origin.x = positionPopControl(index-1)
            UIView.animate(withDuration: UINavigationControllerHideShowBarDuration) {
                self.underline.frame.size.width = underlineWidth
                popControl.frame.origin.x = self.positionPopControl(index)
            }
        } else {
            popControl.frame.origin.x = positionPopControl(index)
            underline.frame.size.width = underlineWidth
        }
    }
}


//-----------------------------------------------------------------------------
// MARK: - pop
extension AZNavigationController {
    override open func popViewController(animated: Bool) -> UIViewController? {
        let vc = super.popViewController(animated: animated)
        
        if animated {
            if let coordinator = transitionCoordinator {
                coordinator.animate(alongsideTransition: nil) { _ in
                    self.didPop(animated)
                }
            }
        }
        else {
            self.didPop(animated)
        }
        
        return vc
    }
    
    private func didPop(_ animated: Bool) {
        if popControls.count == self.viewControllers.count, let popControl = popControls.last {
            
            let index = viewControllers.count - 1
            let isFirst = index == 0
            
            print("didPop: \(index)")
            
            if animated {
                
                UIView.animate(withDuration: UINavigationControllerHideShowBarDuration) {
                    popControl.frame.origin.x = self.navigationBar.frame.maxX
                    self.underline.frame.size.width = self.positionUnderline(index - 1)
                } completion: { isFinish in
                    popControl.removeFromSuperview()
                    self.popControls.removeLast()
                    if isFirst {
                        self.underline.removeFromSuperview()
                    }
                }

            } else {
                popControl.removeFromSuperview()
                popControls.removeLast()
                underline.frame.size.width = positionUnderline(index - 1)
                if isFirst {
                    self.underline.removeFromSuperview()
                }
            }
        }
    }
}
