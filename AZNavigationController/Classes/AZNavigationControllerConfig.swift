//
//  AZNavigationControllerConfig.swift
//  AZNavigationController
//
//  Created by minkook yoo on 2022/02/17.
//

import Foundation


typealias AZConfig = AZNavigationControllerConfig


enum AZPopControlImageType: String, CaseIterable {
    case run = "run"
    case bat = "bat"
    case dynamic = "dynamic_run"
    case fly = "fly"
    case player = "player"
    case red = "red"
}


struct AZNavigationControllerConfig {
    
    
    // MARK: - control item
    
    // control item limit
    static let PopControlItem_LimitCount: Int = 5
    
    
    
    // MARK: - control item design
    
    // item type
    static let PopControlImageType: AZPopControlImageType = .run
    
    // item size
    static let PopControlItem_Width: CGFloat = 44.0
    
    // item spacing
    static let PopControlItem_Spacing: CGFloat = 0.0
    
    // item left
    static let NavigationBarBackItem_Width: CGFloat = 44.0
    
    
    
    // MARK: - control item image
    
    // image size
    static let PopControlItem_ImageWidth: CGFloat = 25.0
    static let PopControlItem_ImageHeight: CGFloat = 30.0
    
    // image resource bundle
    static let ImageDefaultBundle: Bundle? = {
        let bundle = Bundle(for: AZNavigationController.self)
        guard let url = bundle.url(forResource: "AZNavigationController", withExtension: "bundle") else {
            return bundle
        }
        return Bundle(url: url)
    }()
    
    
    // MARK: - underline
    
    // underline size
    static let PopControlUnderline_Height: CGFloat = 8.0
    
    // underline color
    static let PopControlUnderline_Color: UIColor = .lightGray
    
}
