//
//  OfferItem.m
//  AppManager
//
//  Created by Stepan Stepanov on 01.05.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "OfferItem.h"

@implementation OfferItem


-(instancetype)initWith:(NSDictionary*)dictionary {

    if (self = [super initWith:dictionary]) {
        _brandName = [dictionary valueForKey:@"brand"];
        _name = [dictionary valueForKey:@"title"];
        _size = [dictionary valueForKey:@"size"];
        _likesCount = [NSNumber numberWithInt:(arc4random() % 1000) + 100];
        _price = [[dictionary valueForKey:@"price"] intValue];
        _photoUrls = [NSMutableArray array];
        for (NSDictionary* photo in [dictionary objectForKey:@"photo_urls"]) {
            [_photoUrls addObject:[photo valueForKey:@"url"]];
        }
        if (!_photoUrls) {
            _photoUrls = [NSMutableArray arrayWithObject:@"https://static-mercariapp-com.akamaized.net/photos/m944492977_1.jpg?1463985609"];
        }
        _category = [dictionary valueForKey:@"category_id"];
        _shipping = [dictionary valueForKey:@"shipping"];
        _created = [dictionary valueForKey:@"created"];
        _itemDescription = [dictionary valueForKey:@"description"];
        _senderCity = [dictionary valueForKey:@"senderCity"];
        _condition = [dictionary valueForKey:@"item_condition"];
        _seller = [[UserItem alloc] initWith:[dictionary valueForKey:@"seller"]];
        _categories = [NSMutableArray arrayWithArray:[[dictionary valueForKey:@"categories"] componentsSeparatedByString:@","]];
    }
    return self;
}

@end
