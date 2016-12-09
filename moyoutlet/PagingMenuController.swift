//
//  PagingMenuController.swift
//  PagingMenuController
//
//  Created by Yusuke Kita on 3/18/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import UIKit

@objc public protocol PagingMenuControllerDelegate: class {
    @objc optional func willMoveToPageMenuController(_ menuController: UIViewController, previousMenuController: UIViewController)
    @objc optional func didMoveToPageMenuController(_ menuController: UIViewController, previousMenuController: UIViewController)
}

open class PagingMenuController: UIViewController {
    
    weak open var delegate: PagingMenuControllerDelegate?
    open fileprivate(set) var menuView: MenuView!
    open fileprivate(set) var currentPage: Int = 0
    open fileprivate(set) var currentViewController: UIViewController!
    open fileprivate(set) var visiblePagingViewControllers = [UIViewController]()
    open fileprivate(set) var pagingViewControllers = [UIViewController]() {
        willSet {
            options.menuItemCount = newValue.count
            options.menuItemViewContent = newValue.flatMap({ $0.menuItemImage }).isEmpty ? .text : .image
            switch options.menuItemViewContent {
            case .text: menuItemTitles = newValue.map { $0.title ?? "Menu" }
            case .image: menuItemImages = newValue.map { $0.menuItemImage ?? UIImage() }
            }
        }
        didSet {
            cleanup()
        }
    }
    
    fileprivate var options: PagingMenuOptions!
    fileprivate let visiblePagingViewNumber: Int = 3
    fileprivate let contentScrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    fileprivate let contentView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    fileprivate var menuItemTitles: [String] = []
    fileprivate var menuItemImages: [UIImage] = []
    fileprivate enum PagingViewPosition {
        case left, center, right, unknown
        
        init(order: Int) {
            switch order {
            case 0: self = .left
            case 1: self = .center
            case 2: self = .right
            default: self = .unknown
            }
        }
    }
    fileprivate var previousIndex: Int {
        guard case .infinite = options.menuDisplayMode else { return currentPage - 1 }
        
        return currentPage - 1 < 0 ? options.menuItemCount - 1 : currentPage - 1
    }
    fileprivate var nextIndex: Int {
        guard case .infinite = options.menuDisplayMode else { return currentPage + 1 }
        
        return currentPage + 1 > options.menuItemCount - 1 ? 0 : currentPage + 1
    }
    fileprivate var currentPagingViewPosition: PagingViewPosition {
        let pageWidth = contentScrollView.frame.width
        let order = Int(ceil((contentScrollView.contentOffset.x - pageWidth / 2) / pageWidth))
        
        if case .infinite = options.menuDisplayMode {
            return PagingViewPosition(order: order)
        }
        
        // consider left edge menu as center position
        guard currentPage == 0 && contentScrollView.contentSize.width < (pageWidth * CGFloat(visiblePagingViewNumber)) else { return PagingViewPosition(order: order) }
        return PagingViewPosition(order: order + 1)
    }
    lazy fileprivate var shouldLoadPage: (Int) -> Bool = { [unowned self] in
        switch (self.options.menuControllerSet, self.options.lazyLoadingPage) {
        case (.single, _),
             (_, .one):
            guard $0 == self.currentPage else { return false }
        case (_, .three):
            if case .infinite = self.options.menuDisplayMode {
                guard $0 == self.currentPage || $0 == self.previousIndex || $0 == self.nextIndex else { return false }
            } else {
                guard $0 >= self.previousIndex && $0 <= self.nextIndex else { return false }
            }
        }
        return true
    }
    
    lazy fileprivate var isVisiblePagingViewController: (UIViewController) -> Bool = { [unowned self] in
        return self.childViewControllers.contains($0)
    }
    
    fileprivate let ExceptionName = "PMCException"

    // MARK: - Lifecycle
    
    public init(viewControllers: [UIViewController], options: PagingMenuOptions) {
        super.init(nibName: nil, bundle: nil)
        
        setup(viewControllers, options: options)
    }
    
    convenience public init(viewControllers: [UIViewController]) {
        self.init(viewControllers: viewControllers, options: PagingMenuOptions())
    }
    
    public init(menuItemTypes: [MenuItemType], options: PagingMenuOptions) {
        super.init(nibName: nil, bundle: nil)
        
        setup(menuItemTypes, options: options)
    }
    
    convenience public init(menuItemTypes: [MenuItemType]) {
        self.init(menuItemTypes: menuItemTypes, options: PagingMenuOptions())
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        positionMenuController()
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // fix unnecessary inset for menu view when implemented by programmatically
        menuView?.contentInset.top = 0

        // position paging views correctly after view size is decided
        positionMenuController()
    }
    
    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if let menuView = menuView {
            menuView.updateMenuViewConstraints(size: size)
            
            coordinator.animate(alongsideTransition: { [unowned self] (_) -> Void in
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
                
                // reset selected menu item view position
                switch self.options.menuDisplayMode {
                case .standard, .infinite:
                    self.moveToMenuPage(self.currentPage, animated: true)
                default: break
                }
                }, completion: nil)
        }
    }
    
    // MARK: - Public
    
    open func setup(_ viewControllers: [UIViewController], options: PagingMenuOptions) {
        self.options = options
        pagingViewControllers = viewControllers
        visiblePagingViewControllers.reserveCapacity(visiblePagingViewNumber)
        
        // validate
        validateDefaultPage()
        validatePageNumbers()
        
        currentPage = options.defaultPage
        
        setupMenuView()
        setupMenuController()
        
        currentViewController = pagingViewControllers[currentPage]
        moveToMenuPage(currentPage, animated: false)
    }
    
    fileprivate func setupMenuView() {
        switch options.menuComponentType {
        case .menuController: return
        default: break
        }
        
        constructMenuView()
        layoutMenuView()
    }
    
    fileprivate func setupMenuController() {
        switch options.menuComponentType {
        case .menuView: return
        default: break
        }
        
        setupContentScrollView()
        layoutContentScrollView()
        setupContentView()
        layoutContentView()
        constructPagingViewControllers()
        layoutPagingViewControllers()
    }
    
    open func setup(_ menuItemTypes: [MenuItemType], options: PagingMenuOptions) {
        self.options = options
        currentPage = options.defaultPage
        options.menuComponentType = .menuView
        
        if let title = menuItemTypes.first, title is String {
            options.menuItemViewContent = .text
            menuItemTitles = menuItemTypes.map { $0 as! String }
        } else if let image = menuItemTypes.first, image is UIImage {
            options.menuItemViewContent = .image
            menuItemImages = menuItemTypes.map { $0 as! UIImage }
        }
        
        setupMenuView()
        
        menuView.moveToMenu(currentPage, animated: false)
    }
    
    open func moveToMenuPage(_ page: Int, animated: Bool = true) {
        switch options.menuComponentType {
        case .menuView, .all:
            // ignore an unexpected page number
            guard page < menuView.menuItemCount else { return }
            
            let lastPage = menuView.currentPage
            guard page != lastPage else {
                // place views on appropriate position
                menuView.moveToMenu(page, animated: animated)
                positionMenuController()
                return
            }
            
            guard options.menuComponentType == .all else {
                updateCurrentPage(page)
                menuView.moveToMenu(page, animated: animated)
                return
            }
        case .menuController:
            guard page < pagingViewControllers.count else { return }
            guard page != currentPage else { return }
        }
        
        // hide paging views if it's moving to far away
        hidePagingMenuControllers(page)
        
        let previousViewController = currentViewController
        
        delegate?.willMoveToPageMenuController?(currentViewController, previousMenuController: previousViewController!)
        updateCurrentPage(page)
        currentViewController = pagingViewControllers[currentPage]
        menuView?.moveToMenu(page)
        
        let duration = animated ? options.animationDuration : 0
        UIView.animate(withDuration: duration, animations: {
            [unowned self] () -> Void in
            self.positionMenuController()
            }, completion: { [weak self] (_) -> Void in
                guard let _ = self else { return }
                
                self!.relayoutPagingViewControllers()
                
                // show paging views
                self!.showPagingMenuControllers()
                
                self!.delegate?.didMoveToPageMenuController?(self!.currentViewController, previousMenuController: previousViewController!)
        }) 
    }
    
    // MARK: - UIGestureRecognizer
    
    internal func handleTapGesture(_ recognizer: UITapGestureRecognizer) {
        guard let menuItemView = recognizer.view as? MenuItemView else { return }
        guard let page = menuView.menuItemViews.index(of: menuItemView), page != menuView.currentPage else { return }
        
        let newPage: Int
        switch self.options.menuDisplayMode {
        case .standard(_, _, .pagingEnabled):
            newPage = page < self.currentPage ? self.currentPage - 1 : self.currentPage + 1
        case .infinite(_, .pagingEnabled):
            if menuItemView.frame.midX > menuView.currentMenuItemView.frame.midX {
                newPage = menuView.nextPage
            } else {
                newPage = menuView.previousPage
            }
        case .infinite: fallthrough
        default:
            newPage = page
        }
        
        moveToMenuPage(newPage)
    }
    
    internal func handleSwipeGesture(_ recognizer: UISwipeGestureRecognizer) {
        guard let menuView = recognizer.view as? MenuView else { return }
        
        let newPage: Int
        switch (recognizer.direction, options.menuDisplayMode) {
        case (UISwipeGestureRecognizerDirection.left, .infinite):
            newPage = menuView.nextPage
        case (UISwipeGestureRecognizerDirection.left, _):
            newPage = min(nextIndex, options.menuItemCount - 1)
        case (UISwipeGestureRecognizerDirection.right, .infinite):
            newPage = menuView.previousPage
        case (UISwipeGestureRecognizerDirection.right, _):
            newPage = max(previousIndex, 0)
        default: return
        }
        
        moveToMenuPage(newPage)
    }
    
    // MARK: - Constructor
    
    fileprivate func constructMenuView() {
        switch options.menuComponentType {
        case .menuController: return
        default: break
        }
        
        switch options.menuItemViewContent {
        case .text: menuView = MenuView(menuItemTypes: menuItemTitles, options: options)
        case .image: menuView = MenuView(menuItemTypes: menuItemImages, options: options)
        }
        
        menuView.delegate = self
        view.addSubview(menuView)
        
        addTapGestureHandlers()
        addSwipeGestureHandlersIfNeeded()
    }
    
    fileprivate func layoutMenuView() {
        let viewsDictionary = ["menuView": menuView]
        
        let verticalConstraints: [NSLayoutConstraint]
        switch options.menuComponentType {
        case .all:
            switch options.menuPosition {
            case .top:
                verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[menuView]", options: [], metrics: nil, views: viewsDictionary)
            case .bottom:
                verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[menuView]|", options: [], metrics: nil, views: viewsDictionary)
            }
        case .menuView:
            verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[menuView]", options: [], metrics: nil, views: viewsDictionary)
        default: return
        }
        
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[menuView]|", options: [], metrics: nil, views: viewsDictionary)
        NSLayoutConstraint.activate(horizontalConstraints + verticalConstraints)
        
        menuView.setNeedsLayout()
        menuView.layoutIfNeeded()
    }
    
    fileprivate func setupContentScrollView() {
        contentScrollView.delegate = self
        contentScrollView.isScrollEnabled = options.scrollEnabled
        view.addSubview(contentScrollView)
    }
    
    fileprivate func layoutContentScrollView() {
        let viewsDictionary: [String: UIView]
        switch options.menuComponentType {
        case .menuController:
            viewsDictionary = ["contentScrollView": contentScrollView]
        default:
            viewsDictionary = ["contentScrollView": contentScrollView, "menuView": menuView]
        }
        
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[contentScrollView]|", options: [], metrics: nil, views: viewsDictionary)
        let verticalConstraints: [NSLayoutConstraint]
        switch (options.menuComponentType, options.menuPosition) {
        case (.menuController, _):
            verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[contentScrollView]|", options: [], metrics: nil, views: viewsDictionary)
        case (_, .top):
            verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[menuView][contentScrollView]|", options: [], metrics: nil, views: viewsDictionary)
        case (_, .bottom):
            verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[contentScrollView][menuView]", options: [], metrics: nil, views: viewsDictionary)
        }
        
        NSLayoutConstraint.activate(horizontalConstraints + verticalConstraints)
    }
    
    fileprivate func setupContentView() {
        contentScrollView.addSubview(contentView)
    }
    
    fileprivate func layoutContentView() {
        let viewsDictionary = ["contentView": contentView, "contentScrollView": contentScrollView]
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[contentView]|", options: [], metrics: nil, views: viewsDictionary)
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[contentView(==contentScrollView)]|", options: [], metrics: nil, views: viewsDictionary)
        
        NSLayoutConstraint.activate(horizontalConstraints + verticalConstraints)
    }
    
    fileprivate func constructPagingViewControllers() {
        for (index, pagingViewController) in pagingViewControllers.enumerated() {
            // construct three child view controllers at a maximum, previous(optional), current and next(optional)
            if !shouldLoadPage(index) {
                // remove unnecessary child view controllers
                if isVisiblePagingViewController(pagingViewController) {
                    pagingViewController.willMove(toParentViewController: nil)
                    pagingViewController.view!.removeFromSuperview()
                    pagingViewController.removeFromParentViewController()
                    
                    if let viewIndex = visiblePagingViewControllers.index(of: pagingViewController) {
                        visiblePagingViewControllers.remove(at: viewIndex)
                    }
                }
                continue
            }
            
            // ignore if it's already added
            if isVisiblePagingViewController(pagingViewController) {
                continue
            }
            
            guard let pagingView = pagingViewController.view else {
                fatalError("\(pagingViewController) doesn't have any view")
            }
            
            pagingView.frame = .zero
            pagingView.translatesAutoresizingMaskIntoConstraints = false

            contentView.addSubview(pagingView)
            addChildViewController(pagingViewController as UIViewController)
            pagingViewController.didMove(toParentViewController: self)
            
            visiblePagingViewControllers.append(pagingViewController)
        }
    }
    
    fileprivate func layoutPagingViewControllers() {
        // cleanup
        NSLayoutConstraint.deactivate(contentView.constraints)

        var viewsDictionary: [String: AnyObject] = ["contentScrollView": contentScrollView]
        for (index, pagingViewController) in pagingViewControllers.enumerated() {
            if !shouldLoadPage(index) {
                continue
            }
            
            viewsDictionary["pagingView"] = pagingViewController.view!
            var horizontalVisualFormat = String()
            
            // only one view controller
            if options.menuItemCount == options.minumumSupportedViewCount ||
                options.lazyLoadingPage == .one ||
                options.menuControllerSet == .single {
                horizontalVisualFormat = "H:|[pagingView(==contentScrollView)]|"
            } else {
                if case .infinite = options.menuDisplayMode {
                    if index == currentPage {
                        viewsDictionary["previousPagingView"] = pagingViewControllers[previousIndex].view
                        viewsDictionary["nextPagingView"] = pagingViewControllers[nextIndex].view
                        horizontalVisualFormat = "H:[previousPagingView][pagingView(==contentScrollView)][nextPagingView]"
                    } else if index == previousIndex {
                        horizontalVisualFormat = "H:|[pagingView(==contentScrollView)]"
                    } else if index == nextIndex {
                        horizontalVisualFormat = "H:[pagingView(==contentScrollView)]|"
                    }
                } else {
                    if index == 0 || index == previousIndex {
                        horizontalVisualFormat = "H:|[pagingView(==contentScrollView)]"
                    } else {
                        viewsDictionary["previousPagingView"] = pagingViewControllers[index - 1].view
                        if index == pagingViewControllers.count - 1 || index == nextIndex {
                            horizontalVisualFormat = "H:[previousPagingView][pagingView(==contentScrollView)]|"
                        } else {
                            horizontalVisualFormat = "H:[previousPagingView][pagingView(==contentScrollView)]"
                        }
                    }
                }
            }
            
            let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: horizontalVisualFormat, options: [], metrics: nil, views: viewsDictionary)
            let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[pagingView(==contentScrollView)]|", options: [], metrics: nil, views: viewsDictionary)
            
            NSLayoutConstraint.activate(horizontalConstraints + verticalConstraints)
        }

        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    fileprivate func relayoutPagingViewControllers() {
        constructPagingViewControllers()
        layoutPagingViewControllers()
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    // MARK: - Cleanup
    
    fileprivate func cleanup() {
        visiblePagingViewControllers.removeAll()
        currentViewController = nil
        
        childViewControllers.forEach {
            $0.willMove(toParentViewController: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParentViewController()
        }
        
        if let menuView = self.menuView {
            menuView.cleanup()
            menuView.removeFromSuperview()
            contentScrollView.removeFromSuperview()
        }
    }
    
    // MARK: - Private
    
    fileprivate func positionMenuController() {
        if let currentViewController = currentViewController,
            let currentView = currentViewController.view {
            contentScrollView.contentOffset.x = currentView.frame.minX
        }
    }
    
    fileprivate func updateCurrentPage(_ page: Int) {
        let currentPage = page % options.menuItemCount
        self.currentPage = currentPage
    }
    
    fileprivate func hidePagingMenuControllers(_ page: Int) {
        switch (options.lazyLoadingPage, options.menuDisplayMode, page) {
        case (.three, .infinite, menuView?.previousPage ?? previousIndex),
             (.three, .infinite, menuView?.nextPage ?? nextIndex),
             (.three, _, previousIndex),
             (.three, _, nextIndex): break
        default: visiblePagingViewControllers.forEach { $0.view.alpha = 0 }
        }
    }
    
    fileprivate func showPagingMenuControllers() {
        visiblePagingViewControllers.forEach { $0.view.alpha = 1 }
    }
    
    // MARK: - Gesture handler
    
    fileprivate func addTapGestureHandlers() {
        menuView.menuItemViews.forEach {
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PagingMenuController.handleTapGesture(_:)))
            gestureRecognizer.numberOfTapsRequired = 1
            $0.addGestureRecognizer(gestureRecognizer)
        }
    }
    
    fileprivate func addSwipeGestureHandlersIfNeeded() {
        switch options.menuDisplayMode {
        case .standard(_, _, .pagingEnabled): break
        case .infinite(_, .pagingEnabled): break
        default: return
        }
        
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(PagingMenuController.handleSwipeGesture(_:)))
        leftSwipeGesture.direction = .left
        menuView.panGestureRecognizer.require(toFail: leftSwipeGesture)
        menuView.addGestureRecognizer(leftSwipeGesture)
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(PagingMenuController.handleSwipeGesture(_:)))
        rightSwipeGesture.direction = .right
        menuView.panGestureRecognizer.require(toFail: rightSwipeGesture)
        menuView.addGestureRecognizer(rightSwipeGesture)
    }
    
    // MARK: - Validator
    
    fileprivate func validateDefaultPage() {
        guard options.defaultPage >= options.menuItemCount || options.defaultPage < 0 else { return }
        
        NSException(name: NSExceptionName(rawValue: ExceptionName), reason: "default page is invalid", userInfo: nil).raise()
    }
    
    fileprivate func validatePageNumbers() {
        guard case .infinite = options.menuDisplayMode else { return }
        guard options.menuItemCount < visiblePagingViewNumber else { return }
        
        NSException(name: NSExceptionName(rawValue: ExceptionName), reason: "the number of view controllers should be more than three with Infinite display mode", userInfo: nil).raise()
    }
}

extension PagingMenuController: UIScrollViewDelegate {
    fileprivate var nextPageFromCurrentPosition: Int {
        // set new page number according to current moving direction
        let nextPage: Int
        switch currentPagingViewPosition {
        case .left:
            nextPage = options.menuComponentType == .menuController ? previousIndex : menuView.previousPage
        case .right:
            nextPage = options.menuComponentType == .menuController ? nextIndex : menuView.nextPage
        default: nextPage = currentPage
        }
        return nextPage
    }
    
    fileprivate var nextPageFromCurrentPoint: Int {
        let point = CGPoint(x: menuView.contentOffset.x + menuView.frame.width / 2, y: 0)
        for (index, menuItemView) in menuView.menuItemViews.enumerated() {
            guard menuItemView.frame.contains(point) else { continue }
            return index
        }
        return currentPage
    }
    
    // MARK: - UIScrollViewDelegate
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let nextPage: Int
        switch scrollView {
        case let scrollView where scrollView.isEqual(contentScrollView):
            nextPage = nextPageFromCurrentPosition
        case let scrollView where scrollView.isEqual(menuView):
            nextPage = nextPageFromCurrentPoint
        default: return
        }
        
        moveToMenuPage(nextPage)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        switch (scrollView, decelerate) {
        case (let scrollView, false) where scrollView.isEqual(menuView): break
        default: return
        }
        
        let nextPage = nextPageFromCurrentPoint
        moveToMenuPage(nextPage)
    }
}
