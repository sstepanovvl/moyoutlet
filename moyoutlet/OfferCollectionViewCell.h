//
//  OfferCollectionViewCell.h
//  AppManager
//
//  Created by Stepan Stepanov on 01.05.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OfferItem.h"
#import <QuartzCore/QuartzCore.h>

@interface OfferCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) OfferItem* item;

@property (strong, nonatomic) IBOutlet UIView *cellView;
@property (strong, nonatomic) IBOutlet UIView *priceView;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *brandLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *likesCount;
@property (assign, nonatomic) BOOL alreadyShown;

@end
