//
//  MenuView.swift
//  PagingMenuController
//
//  Created by Yusuke Kita on 5/9/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import UIKit

public protocol MenuItemType {}
extension String: MenuItemType {}
extension UIImage: MenuItemType {}

@objc public protocol MenuViewDelegate: class {
    @objc optional func willMoveToMenuItemView(_ menuItemView: MenuItemView, previousMenuItemView: MenuItemView)
    @objc optional func didMoveToMenuItemView(_ menuItemView: MenuItemView, previousMenuItemView: MenuItemView)
}

open class MenuView: UIScrollView {
    weak open var viewDelegate: MenuViewDelegate?
    open fileprivate(set) var menuItemViews = [MenuItemView]()
    open fileprivate(set) var currentPage: Int = 0
    open fileprivate(set) var currentMenuItemView: MenuItemView!
    internal var menuItemCount: Int {
        switch options.menuDisplayMode {
        case .infinite: return options.menuItemCount * options.dummyMenuItemViewsSet
        default: return options.menuItemCount
        }
    }
    internal var previousPage: Int {
        return currentPage - 1 < 0 ? menuItemCount - 1 : currentPage - 1
    }
    internal var nextPage: Int {
        return currentPage + 1 > menuItemCount - 1 ? 0 : currentPage + 1
    }
    fileprivate var sortedMenuItemViews = [MenuItemView]()
    fileprivate var options: PagingMenuOptions!
    
    fileprivate let contentView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy fileprivate var underlineView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    lazy fileprivate var roundRectView: UIView = {
        let view = UIView(frame: .zero)
        view.isUserInteractionEnabled = true
        return view
    }()
    fileprivate var menuViewBounces: Bool {
        switch options.menuDisplayMode {
        case .standard(_, _, .scrollEnabledAndBouces),
             .infinite(_, .scrollEnabledAndBouces): return true
        default: return false
        }
    }
    fileprivate var menuViewScrollEnabled: Bool {
        switch options.menuDisplayMode {
        case .standard(_, _, .scrollEnabledAndBouces),
             .standard(_, _, .scrollEnabled),
             .infinite(_, .scrollEnabledAndBouces),
             .infinite(_, .scrollEnabled): return true
        default: return false
        }
    }
    fileprivate var contentOffsetX: CGFloat {
        switch options.menuDisplayMode {
        case let .standard(_, centerItem, _) where centerItem:
            return centerOfScreenWidth
        case .segmentedControl:
            return contentOffset.x
        case .infinite:
            return centerOfScreenWidth
        default:
            return contentOffsetXForCurrentPage
        }
    }
    fileprivate var centerOfScreenWidth: CGFloat {
        return menuItemViews[currentPage].frame.midX - UIApplication.shared.keyWindow!.bounds.width / 2
    }
    fileprivate var contentOffsetXForCurrentPage: CGFloat {
        guard menuItemCount > options.minumumSupportedViewCount else { return 0.0 }
        let ratio = CGFloat(currentPage) / CGFloat(menuItemCount - 1)
        return (contentSize.width - frame.width) * ratio
    }
    lazy fileprivate var rawIndex: (Int) -> Int = { [unowned self] in
        let count = self.menuItemCount
        let startIndex = self.currentPage - count / 2
        return (startIndex + $0 + count) % count
    }
    
    // MARK: - Lifecycle
    
    internal init<Element: MenuItemType>(menuItemTypes: [Element], options: PagingMenuOptions) {
        super.init(frame: .zero)
        
        self.options = options
        self.options.menuItemCount = menuItemTypes.count
        commonInit({ self.constructMenuItemViews(menuItemTypes) })
    }
    
    fileprivate func commonInit(_ constructor: () -> Void) {
        setupScrollView()
        layoutScrollView()
        setupContentView()
        layoutContentView()
        setupRoundRectViewIfNeeded()
        constructor()
        layoutMenuItemViews()
        setupUnderlineViewIfNeeded()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        adjustmentContentInsetIfNeeded()
    }
    
    // MARK: - Internal method
    
    internal func moveToMenu(_ page: Int, animated: Bool = true) {
        let duration = animated ? options.animationDuration : 0
        let previousPage = currentPage
        currentPage = page
        
        // hide menu view when constructing itself
        if !animated {
            alpha = 0
        }
        
        let menuItemView = menuItemViews[page]
        let previousMenuItemView = currentMenuItemView
        
        if let previousMenuItemView = previousMenuItemView, page != previousPage {
            viewDelegate?.willMoveToMenuItemView?(menuItemView, previousMenuItemView: previousMenuItemView)
        }
        
        UIView.animate(withDuration: duration, animations: { [unowned self] () -> Void in
            self.focusMenuItem()
            if self.options.menuSelectedItemCenter {
                self.positionMenuItemViews()
            }
        }, completion: { [weak self] (_) in
            guard let _ = self else { return }
            
            // relayout menu item views dynamically
            if case .infinite = self!.options.menuDisplayMode {
                self!.relayoutMenuItemViews()
            }
            if self!.options.menuSelectedItemCenter {
                self!.positionMenuItemViews()
            }
            self!.setNeedsLayout()
            self!.layoutIfNeeded()
            
            // show menu view when constructing is done
            if !animated {
                self!.alpha = 1
            }
            
            if let previousMenuItemView = previousMenuItemView, page != previousPage {
                self!.viewDelegate?.didMoveToMenuItemView?(self!.currentMenuItemView, previousMenuItemView: previousMenuItemView)
            }
        }) 
    }
    
    internal func updateMenuViewConstraints(size: CGSize) {
        if case .segmentedControl = options.menuDisplayMode {
            menuItemViews.forEach { $0.updateConstraints(size) }
        }
        setNeedsLayout()
        layoutIfNeeded()

        animateUnderlineViewIfNeeded()
        animateRoundRectViewIfNeeded()
    }
    
    internal func cleanup() {
        contentView.removeFromSuperview()
        switch options.menuItemMode {
        case .underline(_, _, _, _): underlineView.removeFromSuperview()
        case .roundRect(_, _, _, _): roundRectView.removeFromSuperview()
        case .none: break
        }
        
        if !menuItemViews.isEmpty {
            menuItemViews.forEach {
                $0.cleanup()
                $0.removeFromSuperview()
            }
        }
    }
    
    // MARK: - Private method
    
    fileprivate func setupScrollView() {
        backgroundColor = options.backgroundColor
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        bounces = menuViewBounces
        isScrollEnabled = menuViewScrollEnabled
        decelerationRate = options.deceleratingRate
        scrollsToTop = false
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    fileprivate func layoutScrollView() {
        let viewsDictionary = ["menuView": self]
        let metrics = ["height": options.menuHeight]
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "V:[menuView(height)]", options: [], metrics: metrics, views: viewsDictionary)
        )
    }
    
    fileprivate func setupContentView() {
        addSubview(contentView)
    }
    
    fileprivate func layoutContentView() {
        let viewsDictionary = ["contentView": contentView, "scrollView": self]
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[contentView]|", options: [], metrics: nil, views: viewsDictionary)
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[contentView(==scrollView)]|", options: [], metrics: nil, views: viewsDictionary)
        
        NSLayoutConstraint.activate(horizontalConstraints + verticalConstraints)
    }
    
    fileprivate func constructMenuItemViews<Element: MenuItemType>(_ menuItemTypes: [Element]) {
        constructMenuItemViews({
            switch self.options.menuItemViewContent {
            case .text: return MenuItemView(title: menuItemTypes[$0] as! String, options: self.options, addDivider: $1)
            case .image: return MenuItemView(image: menuItemTypes[$0] as! UIImage, options: self.options, addDivider: $1)
            }
        })
    }
    
    fileprivate func constructMenuItemViews(_ constructor: (Int, Bool) -> MenuItemView) {
        for index in 0..<menuItemCount {
            let addDivider = index < menuItemCount - 1
            let menuItemView = constructor(index % options.menuItemCount, addDivider)
            menuItemView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(menuItemView)
            
            menuItemViews.append(menuItemView)
        }
        
        sortMenuItemViews()
    }
    
    fileprivate func sortMenuItemViews() {
        if !sortedMenuItemViews.isEmpty {
            sortedMenuItemViews.removeAll()
        }
        
        if case .infinite = options.menuDisplayMode {
            for i in 0..<menuItemCount {
                let index = rawIndex(i)
                sortedMenuItemViews.append(menuItemViews[index])
            }
        } else {
            sortedMenuItemViews = menuItemViews
        }
    }
    
    fileprivate func layoutMenuItemViews() {
        NSLayoutConstraint.deactivate(contentView.constraints)
        
        for (index, menuItemView) in sortedMenuItemViews.enumerated() {
            let visualFormat: String;
            var viewsDicrionary = ["menuItemView": menuItemView]
            if index == 0 {
                visualFormat = "H:|[menuItemView]"
            } else  {
                viewsDicrionary["previousMenuItemView"] = sortedMenuItemViews[index - 1]
                if index == menuItemCount - 1 {
                    visualFormat = "H:[previousMenuItemView][menuItemView]|"
                } else {
                    visualFormat = "H:[previousMenuItemView][menuItemView]"
                }
            }
            let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: visualFormat, options: [], metrics: nil, views: viewsDicrionary)
            let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[menuItemView]|", options: [], metrics: nil, views: viewsDicrionary)
            
            NSLayoutConstraint.activate(horizontalConstraints + verticalConstraints)
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    fileprivate func setupUnderlineViewIfNeeded() {
        guard case let .underline(height, color, horizontalPadding, verticalPadding) = options.menuItemMode else { return }
        
        let width = menuItemViews[currentPage].bounds.width - horizontalPadding * 2
        underlineView.frame = CGRect(x: horizontalPadding, y: options.menuHeight - (height + verticalPadding), width: width, height: height)
        underlineView.backgroundColor = color
        contentView.addSubview(underlineView)
    }
    
    fileprivate func setupRoundRectViewIfNeeded() {
        guard case let .roundRect(radius, _, verticalPadding, selectedColor) = options.menuItemMode else { return }
        
        let height = options.menuHeight - verticalPadding * 2
        roundRectView.frame = CGRect(x: 0, y: verticalPadding, width: 0, height: height)
        roundRectView.layer.cornerRadius = radius
        roundRectView.backgroundColor = selectedColor
        contentView.addSubview(roundRectView)
    }
    
    fileprivate func animateUnderlineViewIfNeeded() {
        guard case let .underline(_, _, horizontalPadding, _) = options.menuItemMode else { return }
        
        let targetFrame = menuItemViews[currentPage].frame
        underlineView.frame.origin.x = targetFrame.minX + horizontalPadding
        underlineView.frame.size.width = targetFrame.width - horizontalPadding * 2
    }
    
    fileprivate func animateRoundRectViewIfNeeded() {
        guard case let .roundRect(_, horizontalPadding, _, _) = options.menuItemMode else { return }
        
        let targetFrame = menuItemViews[currentPage].frame
        roundRectView.frame.origin.x = targetFrame.minX + horizontalPadding
        roundRectView.frame.size.width = targetFrame.width - horizontalPadding * 2
    }

    fileprivate func relayoutMenuItemViews() {
        sortMenuItemViews()
        layoutMenuItemViews()
    }

    fileprivate func positionMenuItemViews() {
        contentOffset.x = contentOffsetX
        animateUnderlineViewIfNeeded()
        animateRoundRectViewIfNeeded()
    }
    
    fileprivate func adjustmentContentInsetIfNeeded() {
        switch options.menuDisplayMode {
        case let .standard(_, centerItem, _) where centerItem: break
        default: return
        }
        
        let firstMenuView = menuItemViews.first!
        let lastMenuView = menuItemViews.last!
        
        var inset = contentInset
        let halfWidth = frame.width / 2
        inset.left = halfWidth - firstMenuView.frame.width / 2
        inset.right = halfWidth - lastMenuView.frame.width / 2
        contentInset = inset
    }
    
    fileprivate func focusMenuItem() {
        let selected: (MenuItemView) -> Bool = { self.menuItemViews.index(of: $0) == self.currentPage }
        
        // make selected item focused
        menuItemViews.forEach {
            $0.selected = selected($0)
            if $0.selected {
                self.currentMenuItemView = $0
            }
        }

        // make selected item foreground
        sortedMenuItemViews.forEach { $0.layer.zPosition = selected($0) ? 0 : -1 }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
}
