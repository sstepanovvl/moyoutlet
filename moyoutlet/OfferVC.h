//
//  OfferVC.h
//  AppManager
//
//  Created by Stepan Stepanov on 01.05.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "baseVC.h"
#import "OfferItem.h"
#import "OffersVC.h"
#import "OfferCollectionViewCell.h"
#import "PhotoCollectionViewCell.h"
#import "EXPhotoViewer.h"
#import "moyoutlet-swift.h"

@interface OfferVC : baseVC <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong,nonatomic) OfferItem* offerItem;
@property (strong, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (strong, nonatomic) CategoriesWithOffersVC* categoriesWithOffersvc;
@property (strong, nonatomic) IBOutlet UIButton *commentsButton;
@property (strong, nonatomic) IBOutlet UIButton *likeCountsButton;
@property (strong, nonatomic) IBOutlet UIButton *commentsCountButton;
@property (strong, nonatomic) IBOutlet UIView *descriptionView;
@property (strong, nonatomic) IBOutlet UILabel *offerTitle;
@property (strong, nonatomic) IBOutlet UIView *sizeView;
@property (strong, nonatomic) IBOutlet UILabel *offerTitle1;
@property (strong, nonatomic) IBOutlet UILabel *offerSize;
@property (strong, nonatomic) IBOutlet UILabel *offerCreatonDate;

@property (strong, nonatomic) IBOutlet UIView *detailsHeaderView;
@property (strong, nonatomic) IBOutlet UIView *detailsView;
@property (strong, nonatomic) IBOutlet UIView *offerCategory;
@property (strong, nonatomic) IBOutlet UILabel *offerSize1;
@property (strong, nonatomic) IBOutlet UILabel *offerCondition;
@property (strong, nonatomic) IBOutlet UILabel *offerShipping;


@property (strong, nonatomic) IBOutlet UIView *commentsHeaderView;
@property (strong, nonatomic) IBOutlet UIView *sellerHeaderView;
@property (strong, nonatomic) IBOutlet UIControl *sellerDetailView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UIButton *footerBuyButton;
@property (strong, nonatomic) IBOutlet UILabel *footerPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *footerShippingLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *offersCollectionView;



-(instancetype)initWithOfferItem:(OfferItem*)item;


@end
