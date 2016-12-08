//
//  PagingMenuOptions.swift
//  PagingMenuController
//
//  Created by Yusuke Kita on 5/17/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import UIKit

public class PagingMenuOptions {
    public var defaultPage = 0
    public var scrollEnabled = true // in case of using swipable cells, set false
    public var backgroundColor = UIColor.whiteColor()
    public var selectedBackgroundColor = UIColor.whiteColor()
    public var textColor = UIColor.appDarkGrayColor()
    public var selectedTextColor = UIColor.appRedColor()
    public var font = UIFont(name: "OpenSans", size: 12)
    public var selectedFont = UIFont(name: "OpenSans-Bold", size: 12)
    public var menuPosition: MenuPosition = .Top
    public var menuHeight: CGFloat = 35
    public var menuItemMargin: CGFloat = 10
    public var menuItemDividerImage: UIImage?
    public var animationDuration: NSTimeInterval = 0.5
    public var deceleratingRate: CGFloat = UIScrollViewDecelerationRateFast
    public var menuDisplayMode = MenuDisplayMode.Infinite(widthMode: PagingMenuOptions.MenuItemWidthMode.Flexible, scrollingMode: PagingMenuOptions.MenuScrollingMode.ScrollEnabledAndBouces)
    public var menuSelectedItemCenter = true
    public var menuItemMode = MenuItemMode.Underline(height: 2, color: UIColor.appRedColor(), horizontalPadding: 0, verticalPadding: 0)
    public var lazyLoadingPage: LazyLoadingPage = .Three
    public var menuControllerSet: MenuControllerSet = .Multiple
    public var menuComponentType: MenuComponentType = .All
    internal var menuItemCount = 0
    internal let minumumSupportedViewCount = 1
    internal let dummyMenuItemViewsSet = 3
    internal var menuItemViewContent: MenuItemViewContent = .Text
    
    public enum MenuPosition {
        case Top
        case Bottom
    }
    
    public enum MenuScrollingMode {
        case ScrollEnabled
        case ScrollEnabledAndBouces
        case PagingEnabled
    }
    
    public enum MenuItemWidthMode {
        case Flexible
        case Fixed(width: CGFloat)
    }
    
    public enum MenuDisplayMode {
        case Standard(widthMode: MenuItemWidthMode, centerItem: Bool, scrollingMode: MenuScrollingMode)
        case SegmentedControl
        case Infinite(widthMode: MenuItemWidthMode, scrollingMode: MenuScrollingMode)
    }
    
    public enum MenuItemMode {
        case None
        case Underline(height: CGFloat, color: UIColor, horizontalPadding: CGFloat, verticalPadding: CGFloat)
        case RoundRect(radius: CGFloat, horizontalPadding: CGFloat, verticalPadding: CGFloat, selectedColor: UIColor)
    }
    
    public enum LazyLoadingPage {
        case One
        case Three
    }
    
    public enum MenuControllerSet {
        case Single
        case Multiple
    }
    
    public enum MenuComponentType {
        case MenuView
        case MenuController
        case All
    }
    
    internal enum MenuItemViewContent {
        case Text, Image
    }
    
    public init() {}
}