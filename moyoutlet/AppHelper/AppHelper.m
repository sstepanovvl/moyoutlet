//
//  AppHelper.m
//  moyOutlet
//
//  Created by Stepan Stepanov on 18.02.17.
//  Copyright © 2017 Stepan Stepanov. All rights reserved.
//

#import "AppHelper.h"

@implementation AppHelper
+(NSDictionary*)searchInDictionaries:(NSMutableArray*)array Value:(id)value forKey:(NSString*)key {
    for (NSDictionary* dic in array) {
        NSLog(@"%@ isEqual? %@",[dic valueForKey:key],value);
        if ([[dic valueForKey:key] isEqual:value]){
            return dic;
        }
    }
    return nil;
}
@end
