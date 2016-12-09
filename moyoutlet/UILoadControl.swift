//
//  UIRefreshControlBottom.swift
//  MovileRecrutamentoIOS
//
//  Created by Felipe Antonio Cardoso on 09/12/15.
//  Copyright © 2015 Felipe Antonio Cardoso. All rights reserved.
//

import UIKit
import Foundation

open class UILoadControl: UIControl {
  
  fileprivate var activityIndicatorView: UIActivityIndicatorView!
  fileprivate var originalDelegate: UIScrollViewDelegate?
  
  internal var target: AnyObject?
  internal var action: Selector!
  
  open var heightLimit: CGFloat = 80.0
  open fileprivate (set) var loading: Bool = false
  
  var scrollView: UIScrollView = UIScrollView()
  
  override open var frame: CGRect {
    didSet{
      if (frame.size.height > heightLimit) && !loading {
        self.sendActions(for: UIControlEvents.valueChanged)
      }
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.initialize()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.initialize()
  }
  
  public init(target: AnyObject?, action: Selector) {
    self.init()
    self.initialize()
    self.target = target
    self.action = action
    addTarget(self.target, action: self.action, for: .valueChanged)
  }
  
  override open func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override open func layoutSubviews() {
    super.layoutSubviews()
  }
  
  /*
   Update layout at finsih to load
   */
  open func endLoading(){
    setLoading(false)
    fixPosition()
  }
  
  open func update() {
    updateUI()
  }
}

extension UILoadControl {
  
  /*
   Initilize the control
   */
  fileprivate func initialize(){
    self.addTarget(self, action: #selector(UILoadControl.didValueChange(_:)), for: .valueChanged)
    setupActivityIndicator()
  }
 
  /*
   Check if the control frame should be updated.
   This method is called after user hits the end of the scrollView
   */
  func updateUI(){
    if self.scrollView.contentSize.height < self.scrollView.bounds.size.height {
      return
    }
    
    let contentOffSetBottom = max(0, ((scrollView.contentOffset.y + scrollView.frame.size.height) - scrollView.contentSize.height))
    if (contentOffSetBottom >= 0 && !loading) || (contentOffSetBottom >= heightLimit && loading) {
      self.updateFrame(CGRect(x: 0.0, y: scrollView.contentSize.height, width: scrollView.frame.size.width, height: contentOffSetBottom))
    }
  }
  
  /*
   Update layout after user scroll the scrollView
   */
  fileprivate func updateFrame(_ rect: CGRect){
    guard let superview = self.superview else {
      return
    }
    
    superview.frame = rect
    frame = superview.bounds
    activityIndicatorView.alpha = (((frame.size.height * 100) / heightLimit) / 100)
    activityIndicatorView.center = CGPoint(x: (frame.size.width / 2), y: (frame.size.height / 2))
  }
  
  /*
   Place control at the scrollView bottom
   */
  fileprivate func fixPosition(){
    self.updateFrame(CGRect(x: 0.0, y: scrollView.contentSize.height, width: scrollView.frame.size.width, height: 0.0))
  }
  
  /*
   Set layout to a "loading" or "not loading" state
   */
  fileprivate func setLoading(_ isLoading: Bool){
    loading = isLoading
    DispatchQueue.main.async { [unowned self] in
      
      var contentInset = self.scrollView.contentInset
      
      if self.loading {
        contentInset.bottom = self.heightLimit
        self.activityIndicatorView.startAnimating()
      }else{
        contentInset.bottom = 0.0
        self.activityIndicatorView.stopAnimating()
      }
      
      self.scrollView.contentInset = contentInset
    }
  }
  
  /*
   Prepare activityIndicator
   */
  fileprivate func setupActivityIndicator(){
    
    if self.activityIndicatorView != nil {
      return
    }
    
    self.activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    self.activityIndicatorView.hidesWhenStopped = false
    self.activityIndicatorView.color = UIColor.darkGray
    self.activityIndicatorView.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
    
    addSubview(self.activityIndicatorView)
    bringSubview(toFront: self.activityIndicatorView)
  }
  
  @objc fileprivate func didValueChange(_ sender: AnyObject?){
    setLoading(true)
  }
  
}
