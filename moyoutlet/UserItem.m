//
//  UserItem.m
//  moyOutlet
//
//  Created by Stepan Stepanov on 28.07.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "UserItem.h"
#import "OfferItem.h"

@implementation UserItem

-(instancetype)initWith:(NSDictionary*)dictionary {

    if (self = [super init]) {

        _firstName = [dictionary valueForKey:@"firstName"];
        _lastName = [dictionary valueForKey:@"lastName"];
        _userID = [[dictionary valueForKey:@"id"] integerValue];
        NSArray* offers_Array = (NSArray*)[dictionary objectForKey:@"offers"];
        _offers = [[NSMutableArray alloc] init];


        for (NSDictionary* offer_dic in offers_Array) {
            OfferItem* offer = [[OfferItem alloc] initWith:offer_dic];
            [_offers addObject:offer];
        }
//        _birthday = [[dictionary valueForKey:@"birthday"] date];
        _photoUrl = [dictionary objectForKey:@"photo_url"];
        _descr = [dictionary objectForKey:@"description"];
    }
    return self;
}

@end
