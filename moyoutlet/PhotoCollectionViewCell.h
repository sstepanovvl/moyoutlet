//
//  PhotoCollectionViewCell.h
//  moyOutlet
//
//  Created by Stepan Stepanov on 29.05.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OfferItem.h"

@interface PhotoCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) OfferItem* item;
@property (strong, nonatomic) IBOutlet UIScrollView *photoScrollView;


-(void)animateZoomIn;
-(void)animateZoomOut;

@end
