//
//  testTableTableViewController.h
//  moyOutlet
//
//  Created by Stepan Stepanov on 16.02.17.
//  Copyright © 2017 Stepan Stepanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "moyoutlet-Swift.h"

@interface testTableTableViewController : BaseTableViewController <UITextViewDelegate,UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate, UICollectionViewDelegate,UICollectionViewDataSource,ImagePickerViewControllerDelegate>

@property (assign, nonatomic) OfferViewControllerMode offerViewControllerMode;
@property (strong, nonatomic) OfferItem* offerItem;
@end
