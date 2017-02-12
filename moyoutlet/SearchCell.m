//
//  SearchCell.m
//  moyOutlet
//
//  Created by Stepan Stepanov on 03.08.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "SearchCell.h"
#import "SelectBrandVC.h"

@implementation SearchCell

-(instancetype)initWithSearchItem:(SearchItem*)searchItem {
    if (self = [super init]) {
        _searchItem = searchItem;
        _cellTitle.text = _searchItem.text;
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
    _cellTitle.text = self.searchItem.text;
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
