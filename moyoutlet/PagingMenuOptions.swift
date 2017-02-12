//
//  PagingMenuOptions.swift
//  PagingMenuController
//
//  Created by Yusuke Kita on 5/17/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import UIKit

open class PagingMenuOptions {
    open var defaultPage = 0
    open var scrollEnabled = true // in case of using swipable cells, set false
    open var backgroundColor = UIColor.white
    open var selectedBackgroundColor = UIColor.white
    open var textColor = UIColor.appDarkGray()
    open var selectedTextColor = UIColor.appRed()
    open var font = UIFont(name: "OpenSans", size: 12)
    open var selectedFont = UIFont(name: "OpenSans-Bold", size: 12)
    open var menuPosition: MenuPosition = .top
    open var menuHeight: CGFloat = 35
    open var menuItemMargin: CGFloat = 10
    open var menuItemDividerImage: UIImage?
    open var animationDuration: TimeInterval = 0.5
    open var deceleratingRate: CGFloat = UIScrollViewDecelerationRateNormal
    open var menuDisplayMode = MenuDisplayMode.infinite(widthMode: .flexible, scrollingMode: .scrollEnabledAndBouces)
    open var menuSelectedItemCenter = true
    open var menuItemMode = MenuItemMode.underline(height: 2, color: UIColor.appRed(), horizontalPadding: 0, verticalPadding: 0)
    open var lazyLoadingPage: LazyLoadingPage = .three
    open var menuControllerSet: MenuControllerSet = .multiple
    open var menuComponentType: MenuComponentType = .all
    internal var menuItemCount = 0
    internal let minumumSupportedViewCount = 1
    internal let dummyMenuItemViewsSet = 3
    internal var menuItemViewContent: MenuItemViewContent = .text
    
    public enum MenuPosition {
        case top
        case bottom
    }
    
    public enum MenuScrollingMode {
        case scrollEnabled
        case scrollEnabledAndBouces
        case pagingEnabled
    }
    
    public enum MenuItemWidthMode {
        case flexible
        case fixed(width: CGFloat)
    }
    
    public enum MenuDisplayMode {
        case standard(widthMode: MenuItemWidthMode, centerItem: Bool, scrollingMode: MenuScrollingMode)
        case segmentedControl
        case infinite(widthMode: MenuItemWidthMode, scrollingMode: MenuScrollingMode)
    }
    
    public enum MenuItemMode {
        case none
        case underline(height: CGFloat, color: UIColor, horizontalPadding: CGFloat, verticalPadding: CGFloat)
        case roundRect(radius: CGFloat, horizontalPadding: CGFloat, verticalPadding: CGFloat, selectedColor: UIColor)
    }
    
    public enum LazyLoadingPage {
        case one
        case three
    }
    
    public enum MenuControllerSet {
        case single
        case multiple
    }
    
    public enum MenuComponentType {
        case menuView
        case menuController
        case all
    }
    
    internal enum MenuItemViewContent {
        case text, image
    }
    
    public init() {}
}
