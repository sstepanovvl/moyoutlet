//
//  NSObject+NSDictionaryRepresentation.m
//  moyOutlet
//
//  Created by Stepan Stepanov on 22.02.17.
//  Copyright © 2017 Stepan Stepanov. All rights reserved.
//

#import "NSObject+NSDictionaryRepresentation.h"
#import <objc/runtime.h>

@implementation NSObject (NSDictionaryRepresentation)
- (NSDictionary *)dictionaryRepresentation {
    unsigned int count = 0;
    // Get a list of all properties in the class.
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        NSString *value = [self valueForKey:key];
        if ([value isKindOfClass:[NSNumber class]]) {
            
            [dictionary setObject:[NSString stringWithFormat:@"%@",value] forKey:key];
        } else {
            if (value){
                    [dictionary setObject:value forKey:key];
            } else {
                [dictionary setObject:@"0" forKey:key];
            }
        }
        // Only add to the NSDictionary if it's not nil.
        
    }
    
    free(properties);
    
    return dictionary;
}
@end
