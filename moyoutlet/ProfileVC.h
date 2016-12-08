//
//  ProfileVC.h
//  moyOutlet
//
//  Created by Stepan Stepanov on 16.07.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "baseVC.h"
#import "OfferCollectionViewCell.h"
#import "OfferVC.h"
#import "OfferLightCollectionViewCell.h"


@interface ProfileVC : baseVC <UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) CategoriesWithOffersVC* categoriesWithOffersvc;
@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *userPoints;
@property (strong, nonatomic) IBOutlet UILabel *userSubscribers;
@property (strong, nonatomic) IBOutlet UIButton *excellentReplies;
@property (strong, nonatomic) IBOutlet UIButton *goodReplies;
@property (strong, nonatomic) IBOutlet UIButton *badReplies;
@property (strong, nonatomic) IBOutlet UIButton *moreDetails;
@property (strong, nonatomic) IBOutlet UITextView *userDescriptionTextView;
@property (strong, nonatomic) IBOutlet UICollectionView *offersCollectionView;
@property (strong, nonatomic) UserItem* user;
@end
