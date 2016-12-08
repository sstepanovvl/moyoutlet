//
//  PhotoCollectionViewCell.m
//  moyOutlet
//
//  Created by Stepan Stepanov on 29.05.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    self.contentView.frame = bounds;
}

-(void)animateZoomIn
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{

        self.transform = CGAffineTransformMakeScale(2,2);
    } completion:^(BOOL finished){

    }];
}

-(void)animateZoomOut
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{

        self.transform = CGAffineTransformMakeScale(1,1);
    } completion:^(BOOL finished){

    }];
}

@end
