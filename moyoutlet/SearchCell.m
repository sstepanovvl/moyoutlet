//
//  SearchCell.m
//  moyOutlet
//
//  Created by Stepan Stepanov on 03.08.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "SearchCell.h"


@implementation SearchCell

-(instancetype)initWithSearchItem:(SearchItem*)searchItem {
    if (self = [super init]) {
        _searchItem = searchItem;
        _cellTitle.text = _searchItem.text;
        if (searchItem.description) {
            _descriptionLabel.text = _searchItem.description;
        }
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _searchItem = [[SearchItem alloc]init];
    // Initialization code
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.delegate = nil;
}


//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:YES];
//    
//    // Configure the view for the selected state
//}

-(void)setSearchItem:(SearchItem *)searchItem {
    _searchItem = searchItem;
    if (_searchItem.hasChild) {
        _selectButtonConstraint.constant = 14.0f;
        _selectButtonTrailingConstraint.constant = 8.0f;
        _selectButton.hidden = NO;
    }
    _cellTitle.text = _searchItem.text;
    _descriptionLabel.text = _searchItem.itemDescription;
}


- (IBAction)selectButtonPressed:(id)sender {
    NSLog(@"Button pressed");
    
    UIButton* button = (UIButton*)sender;
    if (button.tag == 1) {
        if ([self.delegate respondsToSelector:@selector(delegateForCell:showSubItems:)]) {
            [self.delegate delegateForCell:self showSubItems:YES];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(delegateForCell:showSubItems:)]) {
            [self.delegate delegateForCell:self showSubItems:NO];
        }
    }
}



@end
