//
//  WillSendInItem.m
//  moyOutlet
//
//  Created by Stepan Stepanov on 16.02.17.
//  Copyright © 2017 Stepan Stepanov. All rights reserved.
//

#import "WillSendInItem.h"

@implementation WillSendInItem
-(instancetype)initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        _item_id = [dictionary objectForKey:@"id"];
        _item_name = [dictionary objectForKey:@"name"];
        _item_description = [dictionary objectForKey:@"description"];
        return self;
    }else {
        return nil;
    }
}

@end
