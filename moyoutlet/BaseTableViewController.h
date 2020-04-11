//
//  BaseTableViewController.h
//  moyOutlet
//
//  Created by Stepan Stepanov on 16.02.17.
//  Copyright © 2017 Stepan Stepanov. All rights reserved.
//

#import "baseVC.h"
#import "IQKeyboardManager.h"
#import "IQDropDownTextField.h"
#import "IQUIView+IQKeyboardToolbar.h"
#import "IQUITextFieldView+Additions.h"
#import "UITextView+Placeholder.h"
#import "StaticDataTableViewController.h"
#import "HeaderView.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface BaseTableViewController : StaticDataTableViewController <UITableViewDelegate>
-(void)dismissNavigationController;
-(IBAction)backButtonPressed;
@end
