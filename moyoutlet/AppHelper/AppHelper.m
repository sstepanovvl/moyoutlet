//
//  AppHelper.m
//  moyOutlet
//
//  Created by Stepan Stepanov on 18.02.17.
//  Copyright © 2017 Stepan Stepanov. All rights reserved.
//

#import "AppHelper.h"

@implementation AppHelper
+(NSDictionary*)searchInDictionaries:(NSMutableArray*)array Value:(NSNumber*)value forKey:(NSString*)key {
    for (NSDictionary* dic in array) {
        if ([value respondsToSelector:@selector(stringValue)]) {
            if ([[dic objectForKey:key] isEqualToString:[value stringValue]]){
                return dic;
            }
        } else {
            if ([[dic objectForKey:key] isEqualToString:value]){
                return dic;
            }
        }
    }
    return nil;
}

+(NSString*)numToStr:(NSNumber*)num {
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setUsesGroupingSeparator:YES];
    [formatter setGroupingSize:3];
    [formatter setGroupingSeparator:@"\u00a0"];
    NSString *string = [formatter stringFromNumber:num];
    return string;
}



@end
