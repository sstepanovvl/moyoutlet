//
//  MenuVC.h
//  moyOutlet
//
//  Created by Stepan Stepanov on 14.07.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "baseVC.h"
#import "LeftMenuCell.h"

@interface MenuVC : baseVC <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *credits;
@property (strong, nonatomic) IBOutlet UIButton *offerButton;

@end
