//
//  LeftMenuCell.m
//  AppManager
//
//  Created by Stepan Stepanov on 03.05.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "LeftMenuCell.h"

@implementation LeftMenuCell
@synthesize menuImage;
@synthesize menuTitle;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.menuTitle.text = [[NSString alloc] init];
    self.menuImage.image = [[UIImage alloc] init];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
