//
//  API.m
//  AppManager
//
//  Created by Stepan Stepanov on 24.04.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "API.h"

@interface API ()
@end


@implementation API

#pragma mark Routines

+(void)requestWithMethod:(NSString *)method andData:(NSDictionary*)data withHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))handlerBlock {

    
    if (debug_enabled) {
        NSLog(@"API request method: %@",method);
        NSLog(@"API request data:%@",data);
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@?XDEBUG_SESSION_START=%@", apiServer, method,XDEBUG_SESSION_START];

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

#define POST_BODY_BOURDARY  @"boundary"

+ (void) createOfferWithData:(NSDictionary*)data andImages:(NSArray*)images {
    if(debug_enabled)  {
        NSLog(@"createOfferWithData");
    }
    
    [self requestWithMethod:@"createOffer" andData:data withHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (debug_enabled) {
            NSLog(@"%@",response);
            NSLog(@"received OK, upload images");
        }
        OfferItem* newOffer = [OfferItem new];
        newOffer.objectId = 500;
        int imagePosition = 0;
        for (UIImage* image in images) {
            [self upload:image withImagePosition:imagePosition toOffer:newOffer];
            imagePosition++;
        }
        
    }];
}

+ (void) upload:(UIImage*)image withImagePosition:(int)position toOffer:(OfferItem*)newOffer {
    if(debug_enabled)  {
        NSLog(@"uploadImageToServer");
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@uploadImage?XDEBUG_SESSION_START=%@",apiServer,XDEBUG_SESSION_START]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[self encodeDictionary:@{@"offerId" : [NSNumber numberWithInteger:newOffer.objectId], @"imagePosition" : [NSNumber numberWithInt:position]}]];
    
    NSString *contentTypeValue = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", POST_BODY_BOURDARY];
    [request addValue:contentTypeValue forHTTPHeaderField:@"Content-type"];
    
    NSMutableData *dataForm = [NSMutableData alloc];
    [dataForm appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",POST_BODY_BOURDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [dataForm appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"offerId\";\r\n\r\n%ld", (long)newOffer.objectId]
                          dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    [dataForm appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",POST_BODY_BOURDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    [dataForm appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"imageToUpload[]\"; filename=\"%d\"\r\n", position] dataUsingEncoding:NSUTF8StringEncoding]];
    [dataForm appendData:[[NSString stringWithFormat:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [dataForm appendData:[NSData dataWithData:imageData]];
    
    [dataForm appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",POST_BODY_BOURDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionUploadTask *uploadTask = [[NSURLSession sharedSession] uploadTaskWithRequest:request fromData:dataForm completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            if (debug_enabled) {
                NSLog(@"upload Completed");
                
                NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                NSLog(@"Response data: %@",str);
                
                NSLog(@"NSURLResponse: %@", response);
            }
            
        } else {
            if (debug_enabled) {
                NSLog(@"%@",error.localizedDescription);
            }
        }
        
    }];
    
    [uploadTask resume];
}


@end
