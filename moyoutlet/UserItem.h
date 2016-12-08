//
//  UserItem.h
//  moyOutlet
//
//  Created by Stepan Stepanov on 28.07.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UserItem : NSObject
@property (strong,nonatomic) NSString* firstName;
@property (strong,nonatomic) NSString* lastName;
@property (assign,nonatomic) NSUInteger userID;
@property (assign,nonatomic) NSInteger age;
@property (strong,nonatomic) NSDate* birthday;
@property (strong,nonatomic) NSMutableArray* offers;
@property (strong,nonatomic) NSString* photoUrl;
@property (strong,nonatomic) NSString* descr;

-(instancetype)initWith:(NSDictionary*)dictionary;

@end
