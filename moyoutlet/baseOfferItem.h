//
//  baseOfferItem.h
//  AppManager
//
//  Created by Stepan Stepanov on 01.05.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "ConditionItem.h"
#import "NSObject+NSDictionaryRepresentation.h"

@interface baseOfferItem : NSObject
@property (strong, nonatomic) NSNumber* objectId;

-(instancetype)initWith:(NSDictionary*)dictionary;

-(instancetype)initWithDB;

@end
