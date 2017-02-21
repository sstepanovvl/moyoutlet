//
//  WillSendInItem.h
//  moyOutlet
//
//  Created by Stepan Stepanov on 16.02.17.
//  Copyright © 2017 Stepan Stepanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WillSendInItem : NSObject
@property (assign, nonatomic) NSNumber* item_id;
@property (strong, nonatomic) NSString* item_name;
@property (strong, nonatomic) NSString* item_description;
-(instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end
