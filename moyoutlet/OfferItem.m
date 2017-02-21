//
//  OfferItem.m
//  AppManager
//
//  Created by Stepan Stepanov on 01.05.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "OfferItem.h"
#import "AppManager.h"
@implementation OfferItem

-(instancetype)init {
    if (self = [super init]) {
        self.arrImages = [NSMutableArray arrayWithCapacity:4];
        for (int i = 0; i < 4; i++) {
            [_arrImages addObject:[NSNull null]];
        }

    }
    return self;
}
-(instancetype)initWith:(NSDictionary*)dictionary {

    if (self = [super initWith:dictionary]) {
        
        if ([dictionary valueForKey:@"brand"]) {
            _brand_id = [dictionary valueForKey:@"brand"];
        } else {
            _brand_id = @0;
        }
        
        
        _name = [dictionary valueForKey:@"title"];
        _size_id = [dictionary valueForKey:@"size"];
        _likesCount = [NSNumber numberWithInt:(arc4random() % 1000) + 100];
        _price = [[dictionary valueForKey:@"price"] intValue];
        _photoUrls = [NSMutableArray array];
        _condition_id = [dictionary valueForKey:@"item_condition"] ;
        _willSendIn_id = [dictionary valueForKey:@"willSendIn"];
        
        NSString* imageSize = [NSString string];
        
        if(IS_IPHONE_5 && IS_IPHONE_4_OR_LESS) {
            imageSize = @"260x260";
        } else if (IS_IPHONE_6) {
            imageSize = @"330x330";
        } else if (IS_IPHONE_6P) {
            imageSize = @"550x550";
        }
        
        for (NSDictionary* photo in [dictionary objectForKey:@"photo_urls"]) {
            if (!_mainThumbUrl) {
                _mainThumbUrl = [NSString stringWithFormat:@"%@?size=%@&image=%@",imageServerUrl,imageSize,[photo valueForKey:@"url"]];

            }
            NSString* url = [NSString stringWithFormat:@"%@?image=%@",imageServerUrl,[photo valueForKey:@"url"]];
            [_photoUrls addObject:url];
        }
        
        if (!_photoUrls) {
            _photoUrls = [NSMutableArray arrayWithObject:@"https://static-mercariapp-com.akamaized.net/photos/m944492977_1.jpg?1463985609"];
        }
        _category = [dictionary valueForKey:@"category_id"];
        _category_id = [dictionary valueForKey:@"category_id"];
        _shipping = [dictionary valueForKey:@"shipping"];
        _created = [dictionary valueForKey:@"created"];
        _itemDescription = [dictionary valueForKey:@"description"];
        _senderCity_id = [dictionary valueForKey:@"senderCity"];
        _seller = [[UserItem alloc] initWith:[dictionary valueForKey:@"seller"]];
        _categories = [NSMutableArray arrayWithArray:[[dictionary valueForKey:@"categories"] componentsSeparatedByString:@","]];
    }
    return self;
}


@end
