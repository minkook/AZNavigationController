//
//  AZNavigationControllerConfig.swift
//  AZNavigationController
//
//  Created by minkook yoo on 2022/02/17.
//

import Foundation
import UIKit


public typealias AZConfig = AZNavigationControllerConfig


public enum AZPopControlImageType: String, CaseIterable {
    case run = "run"
    case bat = "bat"
    case dynamic = "dynamic_run"
    case fly = "fly"
    case player = "player"
    case red = "red"
}


public struct AZNavigationControllerConfig {
    
    
    public static var shared = AZNavigationControllerConfig()
    
    
    
    // MARK: - control item
    
    // control item limit
    // default 5
    public var PopControlItem_LimitCount: Int
    
    
    
    // MARK: - control item design
    
    // item type
    // default random
    public var PopControlImageType: AZPopControlImageType
    
    
    // item size
    // default 44.0
    public var PopControlItem_Width: CGFloat
    
    // item spacingsetup
    // default 0.0
    public var PopControlItem_Spacing: CGFloat
    
    
    
    // MARK: - control item image
    
    // image size
    // default (25.0, 30.0)
    public var PopControlItem_ImageSize: CGSize
    
    
    
    // MARK: - underline
    
    // underline size
    // default 4.0
    public var PopControlUnderline_Height: CGFloat
    
    // underline color
    // default .lightGray
    public var PopControlUnderline_Color: UIColor
    
    
    
    // MARK: - init & private
    
    private init() {
        PopControlItem_LimitCount = 5
        PopControlImageType = .allCases.randomElement()!
        PopControlItem_Width = 44.0
        PopControlItem_Spacing = 0.0
        PopControlItem_ImageSize = CGSize(width: 25.0, height: 30.0)
        PopControlUnderline_Height = 4.0
        PopControlUnderline_Color = .lightGray
    }
    
    // item left
    static let NavigationBarBackItem_Width: CGFloat = 44.0
    
    // image resource bundle
    static let ImageDefaultBundle: Bundle? = {
        let bundle = Bundle(for: AZNavigationController.self)
        guard let url = bundle.url(forResource: "AZNavigationController", withExtension: "bundle") else {
            return bundle
        }
        return Bundle(url: url)
    }()
    
}
