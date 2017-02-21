//
//  SearchCell.h
//  moyOutlet
//
//  Created by Stepan Stepanov on 03.08.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchItem.h"
@protocol SearchCellDelegate;

@interface SearchCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *cellTitle;
@property (strong, nonatomic) SearchItem* searchItem;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectButtonTrailingConstraint;
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;

@property (assign, nonatomic) id <SearchCellDelegate> delegate;

-(instancetype)initWithSearchItem:(SearchItem*)searchItem;

@end

@protocol SearchCellDelegate <NSObject>

@optional

- (void)delegateForCell:(SearchCell *)cell showSubItems:(BOOL)showSubItems;

@end
