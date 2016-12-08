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
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _searchItem = [[SearchItem alloc]init];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setSearchItem:(SearchItem *)searchItem {
    _searchItem = searchItem;
    _cellTitle.text = self.searchItem.text;
}

@end
