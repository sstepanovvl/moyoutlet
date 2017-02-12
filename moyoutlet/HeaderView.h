//
//  HeaderView.h
//  moyOutlet
//
//  Created by Stepan Stepanov on 03.08.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UITableViewHeaderFooterView
@property (strong, nonatomic) IBOutlet UILabel *headerTitle;
@property (strong, nonatomic) NSMutableArray* childItems;
@property (strong, nonatomic) NSString* name;
@property (assign, nonatomic) int parent_id;
@property (assign, nonatomic) int item_id;

@end
