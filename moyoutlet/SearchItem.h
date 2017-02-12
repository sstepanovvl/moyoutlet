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
@property (assign,nonatomic) NSInteger item_id;
@property (assign,nonatomic) NSInteger parent_id;
@end
