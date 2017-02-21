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
        self.weights = [NSMutableArray array];
        self.brands = [NSMutableArray array];
        self.cities = [NSMutableArray array];
        self.sizes = [NSMutableArray array];
        self.conditions = [NSMutableArray array];
        self.willSendInFields = [NSMutableArray array];
        self.categories = [NSDictionary new];
    }
    return self;
}
@end
