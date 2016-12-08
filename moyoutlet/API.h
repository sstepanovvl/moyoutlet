//
//  API.h
//  AppManager
//
//  Created by Stepan Stepanov on 24.04.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface API : NSObject
@property (strong,nonatomic) id delegate;

+(void)requestWithMethod:(NSString *)method andData:(NSDictionary*)data withHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))handlerBlock;


@end
