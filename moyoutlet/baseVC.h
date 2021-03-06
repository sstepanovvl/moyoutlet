//
//  baseVC.h
//  AppManager
//
//  Created by Stepan Stepanov on 24.04.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppManager.h"
#import "AppHelper.h"
#import "IQKeyboardManager.h"
#import "IQDropDownTextField.h"
#import "IQUIView+IQKeyboardToolbar.h"
#import "IQUITextFieldView+Additions.h"
#import "UITextView+Placeholder.h"
#import "baseError.h"
#import "NBPhoneNumberUtil.h"
#import "NBAsYouTypeFormatter.h"
#import "CameraViewControllerOld.h"
//#import "SHSPhoneLibrary.h"
#import "IIViewDeckController.h"
#import "UIColor+CustomColors.h"
#import "UIFont+UIFont_appFonts.h"
#import "UIBarButtonItem+Badge.h"
#import "ViewDeck/ViewDeckController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "ARSPopover.h"
#import "SearchItem.h"
#import "UserItem.h"
#import "SearchBar.h"
#import "MOCollectionView.h"
#import "NSObject+NSDictionaryRepresentation.h"
#import "NSDate+TimeAgo.h"
#import "AFNetworking.h"
#import "M13ProgressHUD.h"
#import "M13ProgressViewImage.h"
#import "M13ProgressViewRing.h"
#import "UIApplication+M13ProgressSuite.h"


@interface baseVC : UIViewController <UIPopoverPresentationControllerDelegate,UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIBarButtonItem* rightSearchButtonItem;
@property (strong, nonatomic) UIBarButtonItem* rightBellButton;
@property (strong, nonatomic) UIBarButtonItem* rightNotifyButton;


-(void)notifyButtonPressed;
-(IBAction)searchButtonPressed:(id)sender;
-(void)alertButtonPressed;
-(IBAction)backButtonPressed:(id)sender;

-(void)initSellButton:(UIImageView*)button onView:(UIView*)view;
-(void)showSellButton:(UIImageView*)button onView:(UIView*)view;
-(void)hideSellButton:(UIImageView*)button onView:(UIView*)view;


-(void)showHud;
-(void)hideHud;

-(void)throughError:(NSError*)error;
-(void)initNavigationItems;

- (NSString *)printPriceWithCurrencySymbol:(CGFloat)price;

#pragma mark - sellButton stuff

//-(void)initSellButtonOnFrame;
//-(void)showSellButton;
//-(void)hideSellButton;
//-(void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view;
//-(void)sellButtonPressed:(id)sender;

@end
