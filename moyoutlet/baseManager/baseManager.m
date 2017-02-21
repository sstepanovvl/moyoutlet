//
//  baseManager.m
//  moyOutlet
//
//  Created by Stepan Stepanov on 18.02.17.
//  Copyright © 2017 Stepan Stepanov. All rights reserved.
//

#import "baseManager.h"

@implementation baseManager
+ (instancetype)sharedInstance
{
    static baseManager* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Do any other initialisation stuff here
    });
    
    return sharedInstance;
}

@end
