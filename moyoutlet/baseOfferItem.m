//
//  baseOfferItem.m
//  AppManager
//
//  Created by Stepan Stepanov on 01.05.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "baseOfferItem.h"

@implementation baseOfferItem
-(instancetype)initWith:(NSDictionary*)dictionary {

    if (self = [super init]) {
        self.objectId = [[dictionary valueForKey:@"id"] intValue];
//        NSLog(@"New offer item #%ld initialized with dictionary",(long)self.objectId);

    }
    return self;
}
-(instancetype)initWithDB {

    if (self = [super init]) {
        self.objectId = arc4random() % 255255255;
        NSLog(@"New offer item #%ld initialized with DB",(long)self.objectId);

    }
    return self;

}
@end
