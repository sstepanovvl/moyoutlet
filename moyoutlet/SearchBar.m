//
//  SearchBar.m
//  moyOutlet
//
//  Created by Stepan Stepanov on 21.12.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "SearchBar.h"
#import "UIColor+CustomColors.h"
@implementation SearchBar


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
/*
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame] )
    {
        self.tintColor = [UIColor appDarkGrayColor];
        self.barTintColor = [UIColor whiteColor];
    }
    return self;
    
}


@end
