//
//  OfferItem.h
//  AppManager
//
//  Created by Stepan Stepanov on 01.05.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "baseOfferItem.h"
#import "UserItem.h"

@interface OfferItem : baseOfferItem
@property (strong, nonatomic) NSString* brandName;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* size;
@property (assign, nonatomic) float price;
@property (strong, nonatomic) NSMutableArray* photoUrls;
@property (strong, nonatomic) NSString* mainThumbUrl;
@property (strong, nonatomic) NSNumber* likesCount;
@property (strong, nonatomic) NSString* category;
@property (strong, nonatomic) NSString* shipping;
@property (strong, nonatomic) NSString* created;
@property (strong, nonatomic) NSString* condition;
@property (strong, nonatomic) NSString* itemDescription;
@property (strong, nonatomic) NSString* senderCity;
@property (strong, nonatomic) UserItem* seller;
@property (strong, nonatomic) NSMutableArray* categories;
-(instancetype)initWith:(NSDictionary*)dictionary;

@end
