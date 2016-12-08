//
//  baseError.h
//  AppManager
//
//  Created by Stepan Stepanov on 24.04.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface baseError : NSError
@property (strong,nonatomic) NSString* customHeader;
@property (strong,nonatomic) NSString* customError;
@end
