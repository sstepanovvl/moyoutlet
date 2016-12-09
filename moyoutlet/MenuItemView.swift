//
//  MenuItemView.swift
//  PagingMenuController
//
//  Created by Yusuke Kita on 5/9/15.
//  Copyright (c) 2015 kitasuke. All rights reserved.
//

import UIKit

open class MenuItemView: UIView {
    
    lazy open var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy open var menuImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    open internal(set) var selected: Bool = false {
        didSet {
            if case .roundRect = options.menuItemMode {
                backgroundColor = UIColor.clear
            } else {
                backgroundColor = selected ? options.selectedBackgroundColor : options.backgroundColor
            }
            
            switch options.menuItemViewContent {
            case .text:
                titleLabel.textColor = selected ? options.selectedTextColor : options.textColor
                titleLabel.font = selected ? options.selectedFont : options.font
                // adjust label width if needed
                let labelSize = calculateLabelSize()
                widthConstraint.constant = labelSize.width
            case .image: break
            }
        }
    }
    lazy open fileprivate(set) var dividerImageView: UIImageView? = {
        let imageView = UIImageView(image: self.options.menuItemDividerImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    fileprivate var options: PagingMenuOptions!
    fileprivate var widthConstraint: NSLayoutConstraint!
    fileprivate var labelSize: CGSize {
        guard let text = titleLabel.text else { return .zero }
        return NSString(string: text).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: titleLabel.font], context: nil).size
    }
    fileprivate let labelWidth: (CGSize, PagingMenuOptions.MenuItemWidthMode) -> CGFloat = { size, widthMode in
        switch widthMode {
        case .flexible: return ceil(size.width)
        case .fixed(let width): return width
        }
    }
    fileprivate var horizontalMargin: CGFloat {
        switch options.menuDisplayMode {
        case .segmentedControl: return 0.0
        default: return options.menuItemMargin
        }
    }
    
    // MARK: - Lifecycle
    
    internal init(title: String, options: PagingMenuOptions, addDivider: Bool) {
        super.init(frame: .zero)
        self.options = options
        
        commonInit(addDivider) {
            self.setupLabel(title)
            self.layoutLabel()
        }
    }
    
    internal init(image: UIImage, options: PagingMenuOptions, addDivider: Bool) {
        super.init(frame: .zero)
        self.options = options
        
        commonInit(addDivider) {
            self.setupImageView(image)
            self.layoutImageView()
        }
    }
    
    fileprivate func commonInit(_ addDivider: Bool, setup: () -> Void) {
        setupView()
        
        setup()
        
        if let _ = options.menuItemDividerImage, addDivider {
            setupDivider()
            layoutDivider()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // MARK: - Cleanup
    
    internal func cleanup() {
        switch options.menuItemViewContent {
        case .text: titleLabel.removeFromSuperview()
        case .image: menuImageView.removeFromSuperview()
        }
        
        dividerImageView?.removeFromSuperview()
    }
    
    // MARK: - Constraints manager
    
    internal func updateConstraints(_ size: CGSize) {
        // set width manually to support ratotaion
        switch (options.menuDisplayMode, options.menuItemViewContent) {
        case (.segmentedControl, .text):
            let labelSize = calculateLabelSize(size)
            widthConstraint.constant = labelSize.width
        case (.segmentedControl, .image):
            widthConstraint.constant = size.width / CGFloat(options.menuItemCount)
        default: break
        }
    }
    
    // MARK: - Constructor
    
    fileprivate func setupView() {
        if case .roundRect = options.menuItemMode {
            backgroundColor = UIColor.clear
        } else {
            backgroundColor = options.backgroundColor
        }
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    fileprivate func setupLabel(_ title: String) {
        titleLabel.text = title
        titleLabel.textColor = options.textColor
        titleLabel.font = options.font
        addSubview(titleLabel)
    }
    
    fileprivate func setupImageView(_ image: UIImage) {
        menuImageView.image = image
        addSubview(menuImageView)
    }
    
    fileprivate func setupDivider() {
        guard let dividerImageView = dividerImageView else { return }
        
        addSubview(dividerImageView)
    }

    fileprivate func layoutLabel() {
        let viewsDictionary = ["label": titleLabel]
        
        let labelSize = calculateLabelSize()

        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[label]|", options: [], metrics: nil, views: viewsDictionary)
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[label]|", options: [], metrics: nil, views: viewsDictionary)
        
        NSLayoutConstraint.activate(horizontalConstraints + verticalConstraints)
        
        widthConstraint = NSLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: labelSize.width)
        widthConstraint.isActive = true
    }
    
    fileprivate func layoutImageView() {
        guard let image = menuImageView.image else { return }
        
        let width: CGFloat
        switch options.menuDisplayMode {
        case .segmentedControl:
            width = UIApplication.shared.keyWindow!.bounds.size.width / CGFloat(options.menuItemCount)
        default:
            width = image.size.width + horizontalMargin * 2
        }
        
        widthConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: width)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: menuImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: menuImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: menuImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: image.size.width),
            NSLayoutConstraint(item: menuImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: image.size.height),
            widthConstraint
            ])
    }
    
    fileprivate func layoutDivider() {
        guard let dividerImageView = dividerImageView else { return }
        
        let centerYConstraint = NSLayoutConstraint(item: dividerImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 1.0)
        let rightConstraint = NSLayoutConstraint(item: dividerImageView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0)
        NSLayoutConstraint.activate([centerYConstraint, rightConstraint])
    }

    // MARK: - Size calculator
    
    fileprivate func calculateLabelSize(_ size: CGSize = UIApplication.shared.keyWindow!.bounds.size) -> CGSize {
        guard let _ = titleLabel.text else { return .zero }
        
        let itemWidth: CGFloat
        switch options.menuDisplayMode {
        case let .standard(widthMode, _, _):
            itemWidth = labelWidth(labelSize, widthMode)
        case .segmentedControl:
            itemWidth = size.width / CGFloat(options.menuItemCount)
        case let .infinite(widthMode, _):
            itemWidth = labelWidth(labelSize, widthMode)
        }
        
        let itemHeight = floor(labelSize.height)
        return CGSize(width: itemWidth + horizontalMargin * 2, height: itemHeight)
    }
}
