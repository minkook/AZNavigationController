//
//  AZNavigationControllerConfig.swift
//  AZNavigationController
//
//  Created by minkook yoo on 2022/02/17.
//

import Foundation


typealias AZConfig = AZNavigationControllerConfig

struct AZNavigationControllerConfig {
    
    
    // MARK: - control item
    
    // control item limit
    static let PopControlItem_LimitCount: Int = 5
    
    
    
    // MARK: - control item design
    
    // item size
    static let PopControlItem_Width: CGFloat = 44.0
    
    // item spacing
    static let PopControlItem_Spacing: CGFloat = 0.0
    
    // item left
    static let NavigationBarBackItem_Width: CGFloat = 44.0
    
    
    
    // MARK: - control item image
    
    // image size
    static let PopControlItem_ImageWidth = 25.0
    static let PopControlItem_ImageHeight = 30.0
    
}
