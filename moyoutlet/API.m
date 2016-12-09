//
//  API.m
//  AppManager
//
//  Created by Stepan Stepanov on 24.04.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "API.h"

@implementation API

#pragma mark Routines

+(void)requestWithMethod:(NSString *)method andData:(NSDictionary*)data withHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))handlerBlock {

    
    if (debug_enabled) {
        NSLog(@"API request method: %@",method);
        NSLog(@"API request data:%@",data);
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@.php", apiServer, method];


    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    request.HTTPMethod = @"POST";
    request.HTTPBody = [self encodeDictionary:data];

    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:handlerBlock] resume];
}

+ (NSData*)encodeDictionary:(NSDictionary*)dictionary {
    NSMutableArray *parts = [[NSMutableArray alloc] init];
    for (NSString* key in dictionary) {

        NSString* encodedValue = [NSString string];

        if ([[dictionary objectForKey:key] isKindOfClass:[NSNumber class]]){
            encodedValue = [[[dictionary objectForKey:key] stringValue] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        } else {
            encodedValue = [[dictionary objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        }
        NSString* encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString* part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
        [parts addObject:part];
    }
    NSString *encodedDictionary = [parts componentsJoinedByString:@"&"];
    return [encodedDictionary dataUsingEncoding:NSUTF8StringEncoding];
}


@end
