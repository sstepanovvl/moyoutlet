//
//  SearchCell.h
//  moyOutlet
//
//  Created by Stepan Stepanov on 03.08.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchItem.h"

@interface SearchCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *cellTitle;
@property (strong, nonatomic) SearchItem* searchItem;


-(instancetype)initWithSearchItem:(SearchItem*)searchItem;

@end
