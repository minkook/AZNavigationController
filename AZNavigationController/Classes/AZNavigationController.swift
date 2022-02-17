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
        frame.size.width = itemWidth
        
        let popControl = AZPopControl(frame: frame)
        
        popControl.didEndTrackingNeedPopBlock = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                let vc = self.viewControllers[index]
                let _ = self.popToViewController(vc, animated: true)
            }
        }
        
        return popControl
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
        didPush(animated)
    }
    
    private func didPush(_ animated: Bool) {
        if animated {
            if let coordinator = transitionCoordinator {
                coordinator.animate(alongsideTransition: nil) { _ in
                    self.didPushCore(animated)
                }
            }
        }
        else {
            self.didPushCore(animated)
        }
    }
    
    private func validControl() -> Bool {
        let count = viewControllers.count
        if count == 1 || count > itemLimitCount + 1 {
            return false
        }
        return true
    }
    
    private func didPushCore(_ animated: Bool) {
        if !validControl() { return }
        
        let index = viewControllers.count - 2
        let isFirst = index == 0
        
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
        didPop(animated)
        return vc
    }
    
    override open func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        let vcs = super.popToViewController(viewController, animated: animated)
        didPop(animated)
        return vcs
    }
    
    private func didPop(_ animated: Bool) {
        if animated {
            if let coordinator = transitionCoordinator {
                coordinator.animate(alongsideTransition: nil) { _ in
                    self.didPopCore(animated)
                }
            }
        }
        else {
            self.didPopCore(animated)
        }
    }
    
    private func didPopCore(_ animated: Bool) {
        if popControls.count < self.viewControllers.count {
            return
        }
        
        let index = viewControllers.count - 1
        let isFirst = index == 0
        let removeControls = popControls[index...]
            
        if animated {

            UIView.animate(withDuration: UINavigationControllerHideShowBarDuration) {
                for control in removeControls {
                    control.frame.origin.x = self.navigationBar.frame.maxX
                }
                self.underline.frame.size.width = self.positionUnderline(index - 1)
            } completion: { isFinish in
                for control in removeControls {
                    control.removeFromSuperview()
                }
                self.popControls.removeSubrange(index...)
                if isFirst {
                    self.underline.removeFromSuperview()
                }
            }

        } else {
            for control in removeControls {
                control.removeFromSuperview()
            }
            self.popControls.removeSubrange(index...)
            underline.frame.size.width = positionUnderline(index - 1)
            if isFirst {
                self.underline.removeFromSuperview()
            }
        }
    }
}
