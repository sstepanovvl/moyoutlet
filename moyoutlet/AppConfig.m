//
//  AppConfig.m
//  AppManager
//
//  Created by Stepan Stepanov on 24.04.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "AppConfig.h"

@implementation AppConfig
@synthesize id;
@synthesize version;
@synthesize categories;

-(instancetype)init {

    if (!self) {
        self = [super init];
    }

    return self;
}
@end
