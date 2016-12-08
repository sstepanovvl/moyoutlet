//
//  OfferLightCollectionViewCell.m
//  moyOutlet
//
//  Created by Stepan Stepanov on 29.05.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "OfferLightCollectionViewCell.h"

@implementation OfferLightCollectionViewCell


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // change to our custom selected background view

    }
    return self;
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    self.contentView.frame = bounds;
}

@end
