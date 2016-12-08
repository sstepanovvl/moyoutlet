//
//  baseError.m
//  AppManager
//
//  Created by Stepan Stepanov on 24.04.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "baseError.h"

@implementation baseError

-(instancetype)init{
    if (self = [super init]) {
        self.customError = nil;
    }
    return self;
}

@end
