//
//  categoryItemButton.m
//  test
//
//  Created by Stepan Stepanov on 23.04.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "categoryItemButton.h"

@implementation categoryItemButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = nil;
        self.category_id = 0;
    }
    return self;
}

-(BOOL)isTouchInside {

    if ([self isSelected]) {

    }

    [self.delegate didSelectCategory:self];
    
    return true;

}


@end
