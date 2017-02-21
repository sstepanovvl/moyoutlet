//
//  ConditionItem.m
//  moyOutlet
//
//  Created by Stepan Stepanov on 15.02.17.
//  Copyright © 2017 Stepan Stepanov. All rights reserved.
//

#import "ConditionItem.h"

@implementation ConditionItem
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
