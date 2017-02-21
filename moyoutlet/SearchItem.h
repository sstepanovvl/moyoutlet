//
//  SearchItem.h
//  moyOutlet
//
//  Created by Stepan Stepanov on 03.08.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchItem : NSObject
@property (strong,nonatomic) NSString* text;
@property (assign,nonatomic) NSNumber* item_id;
@property (assign,nonatomic) NSNumber* parent_id;
@property (strong,nonatomic) NSString* itemDescription;
@property (assign,nonatomic) bool hasChild;
@end
