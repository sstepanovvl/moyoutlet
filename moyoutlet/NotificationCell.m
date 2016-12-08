//
//  NotificationCell.m
//  moyOutlet
//
//  Created by Stepan Stepanov on 26.07.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "NotificationCell.h"

@implementation NotificationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _image = [[UIImageView alloc] init];
    _mainTextLabel = [[UILabel alloc] init];
    _daysAgoLabel = [[UILabel alloc] init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
