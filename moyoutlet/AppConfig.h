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
@property (strong,nonatomic) NSMutableArray* brands;
@property (strong,nonatomic) NSMutableArray* cities;
@property (strong,nonatomic) NSMutableArray* willSendInFields;
@property (strong,nonatomic) NSMutableArray* conditions;
@property (strong,nonatomic) NSMutableArray* weights;
@property (strong,nonatomic) NSMutableArray* sizes;
@property (strong,nonatomic) NSDictionary* categories;


@end
