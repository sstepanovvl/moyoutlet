//
//  AppConfig.h
//  AppManager
//
//  Created by Stepan Stepanov on 24.04.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppConfig : NSObject
@property (assign,nonatomic) NSInteger id;
@property (assign,nonatomic) NSInteger version;
@property (strong,nonatomic) NSArray* categories;

@end
