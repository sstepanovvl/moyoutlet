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
    
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@?XDEBUG_SESSION_START=%@", apiServer, method,XDEBUG_SESSION_START];

    if (debug_enabled) {
        NSLog(@"\nURL: **** %@ **** \nAPI request meth: **** %@ **** \nAPI request data: **** %@ ****",urlString,method,data);
    }
    
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
            NSString* encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString* part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
            [parts addObject:part];
        } else if (![[dictionary valueForKey:key] isKindOfClass:[NSDictionary class]]) {
            encodedValue = [[dictionary objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString* encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString* part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
            [parts addObject:part];
        }
        
    }
    NSString *encodedDictionary = [parts componentsJoinedByString:@"&"];
    return [encodedDictionary dataUsingEncoding:NSUTF8StringEncoding];
}

#define POST_BODY_BOURDARY  @"boundary"


+(void)createOfferWithData:(NSDictionary *)data andImages:(NSDictionary*)images progress:(void (^)(NSProgress *))progress withHandler:(void (^)(BOOL))handlerBlock {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];  // allocate AFHTTPManager
    NSString* url = [NSString stringWithFormat:@"%@createOffer?XDEBUG_SESSION_START=%@",apiServer,XDEBUG_SESSION_START];
    [manager POST:url parameters:data constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {  // POST DATA USING MULTIPART CONTENT TYPE

        for (id key in images) {
            UIImage* image = [images valueForKey:key];
            NSData *imageData =  UIImageJPEGRepresentation(image,kJpegCompressionRate);  // convert your image into data
            [formData appendPartWithFileData:imageData
                                        name:key
                                    fileName:key
                                    mimeType:@"image/jpeg"];
            
        }
        NSLog(@"Всё готово к отправке");
    } progress:^(NSProgress* progres){
        progress(progres);
    }success:^(NSURLSessionDataTask *task, id responseObject) {
    
        if (debug_enabled) {
            NSLog(@"Response: \n %@",responseObject);
        }
        
        if ([[responseObject valueForKey:@"id"] integerValue]) {
            handlerBlock(YES);
        } else {
            handlerBlock(NO);
        
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"Error: %@", error);   // Gives Error
                handlerBlock(NO);
    }];
    
}



//+(void) createOfferWithData:(NSDictionary*)data andImages:(NSArray*)images progress:^(NSProgress* progres){
//    //        [imageHUD setProgress:progres.fractionCompleted animated:YES];
//    //        [HUD setProgress:progres.fractionCompleted animated:YES];
//} withHandler:(void (^)(BOOL success))handlerBlock {
//    if(debug_enabled)  {
//        NSLog(@"createOfferWithData");
//    }
//    
//    [self requestWithMethod:@"createOffer" andData:data withHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data
//                                                            options:kNilOptions
//                                                              error:nil];
//        if (debug_enabled) {
//            NSLog(@"Response: \n %@",response);
//            NSLog(@"Data: \n %@",dic);
//        }
//        
//        if ([dic valueForKey:@"id"]) {
//            OfferItem* newOffer = [OfferItem new];
//            newOffer.objectId = [dic valueForKey:@"id"];
//            int imagePosition = 0;
//            for (UIImage* image in images) {
//                [self upload:image withImagePosition:imagePosition toOffer:newOffer];
//                imagePosition++;
//            }
//            handlerBlock(YES);
//        } else {
//            handlerBlock(NO);
//        }
//    }];
//}

+ (void) upload:(UIImage*)image withImagePosition:(int)position toOffer:(OfferItem*)offer {
    if(debug_enabled)  {
        NSLog(@"uploadImageToServer");
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@uploadImage?XDEBUG_SESSION_START=%@",apiServer,XDEBUG_SESSION_START]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[self encodeDictionary:@{@"offerId" : offer.objectId, @"imagePosition" : [NSNumber numberWithInt:position]}]];
    
    NSString *contentTypeValue = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", POST_BODY_BOURDARY];
    [request addValue:contentTypeValue forHTTPHeaderField:@"Content-type"];
    
    NSMutableData *dataForm = [NSMutableData alloc];
    [dataForm appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",POST_BODY_BOURDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [dataForm appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"offerId\";\r\n\r\n%@", offer.objectId]
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
