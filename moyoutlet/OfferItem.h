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
@property (strong, nonatomic) NSNumber* brand_id;
@property (strong, nonatomic) NSNumber* category_id;
@property (strong, nonatomic) NSNumber* willSendIn_id;
@property (strong, nonatomic) NSNumber* condition_id;
@property (strong, nonatomic) NSNumber* senderCity_id;
@property (strong, nonatomic) NSNumber* size_id;
@property (strong, nonatomic) NSNumber* weight_id;
@property (strong, nonatomic) NSNumber* root_category_id;
@property (strong, nonatomic) NSNumber* deliveryEnabled;
@property (assign, nonatomic) NSNumber* deliveryWillSendByMyselfEnabled;
@property (assign, nonatomic) NSNumber* deliverySamovivoznahEnabled;
@property (assign, nonatomic) NSNumber* deliveryOfficeEnabled;
@property (assign, nonatomic) NSNumber* deliveryCourierEnabled;
@property (assign, nonatomic) float price;
@property (assign, nonatomic) float fee;
@property (assign, nonatomic) float clientIncome;
@property (strong, nonatomic) NSMutableArray* photoUrls;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* mainThumbUrl;
@property (strong, nonatomic) NSNumber* likesCount;
@property (strong, nonatomic) NSNumber* commentsCount;
@property (strong, nonatomic) NSString* category;
@property (strong, nonatomic) NSString* shipping;
@property (strong, nonatomic) NSString* willSendIn;
@property (strong, nonatomic) NSDate* created;
@property (strong, nonatomic) ConditionItem* condition;
@property (strong, nonatomic) NSString* itemDescription;
@property (strong, nonatomic) UserItem* seller;
@property (strong, nonatomic) NSMutableArray* categories;
@property (strong, nonatomic) NSDictionary* arrImages;
-(instancetype)initWith:(NSDictionary*)dictionary;


@end
